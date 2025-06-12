import Flutter
import UIKit
import AVKit
import MediaPlayer

public class FlutterAudioPlayerPlugin: NSObject, FlutterPlugin {
  private var player: AVPlayer?
  private var playerItem: AVPlayerItem?
  private var timeObserverToken: Any?
  private var channel: FlutterMethodChannel?
  private var nowPlayingInfo: [String: Any] = [:]
  private var statusObserver: NSKeyValueObservation?
  private var status: String = "idle"

  public static func register(with registrar: FlutterPluginRegistrar) {
      let channel = FlutterMethodChannel(name: "flutter_audio_player_plugin", binaryMessenger: registrar.messenger())
      let instance = FlutterAudioPlayerPlugin()
      registrar.addMethodCallDelegate(instance, channel: channel)
      instance.setupRemoteTransportControls()
      instance.channel = channel

  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "setFilePath":
        guard let args = call.arguments as? [String: Any],
              let filePath = args["filePath"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS",
                              message: "Invalid file path provided",
                              details: nil))
            return
        }
        setFilePath(filePath: filePath, result: result)
    case "loadAudio":
        logPlayerState()
        guard let args = call.arguments as? [String: Any],
              let url = args["url"] as? String,
              let title = args["title"] as? String,
              let artist = args["artist"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
            return
        }
        
        setupAudioSession()
        
        if let audioURL = URL(string: url) {
            // Remove existing observer if any
            if let existingItem = playerItem {
                NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: existingItem)
            }

            playerItem = AVPlayerItem(url: audioURL)
            player = AVPlayer(playerItem: playerItem)

            // Add item completion observer
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(playerDidFinishPlaying),
                name: .AVPlayerItemDidPlayToEndTime,
                object: playerItem
            )
            
            // Add time observer
            let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            timeObserverToken = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
                let position = Int(time.seconds * 1000)
                self?.channel?.invokeMethod("onPositionChanged", arguments: position)
            }
            
            updateNowPlayingInfo(title: title, artist: artist)
            observePlayerStatus(updatedStatus: "ready")
            result(nil)
        } else {
            result(FlutterError(code: "INVALID_URL", message: "Invalid audio URL", details: nil))
        }
        
    case "play":
        guard let args = call.arguments as? [String: Any],
              let urlString = args["url"] as? String,
              let url = URL(string: urlString) else {
            result(FlutterError(code: "INVALID_ARGUMENTS",
                              message: "Invalid URL provided",
                              details: nil))
            return
        }
        play(url: url, result: result)
        
    case "pause":
        pause(result: result)
        
    case "resume":
        resume(result: result)
        
    case "stop":
        stop(result: result)
        
    case "getCurrentPosition":
        getCurrentPosition(result: result)
        
    case "seekTo":
        guard let args = call.arguments as? [String: Any],
              let position = args["position"] as? Int else {
            result(FlutterError(code: "INVALID_ARGUMENTS",
                              message: "Invalid position provided",
                              details: nil))
            return
        }
        seekTo(position: position, result: result)
        
    case "getDuration":
        getDuration(result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

    private func cleanup() {
        stopPositionTimer()
        statusObserver?.invalidate()
        statusObserver = nil

        // Remove completion observer
        if let existingItem = playerItem {
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: existingItem)
        }

        player?.pause()
        player = nil
        playerItem = nil
        observePlayerStatus(updatedStatus: "stopped")
    }

  private func setupRemoteTransportControls() {
      let commandCenter = MPRemoteCommandCenter.shared()
      
      commandCenter.playCommand.addTarget { [weak self] _ in
          self?.player?.play()
          return .success
      }
      
      commandCenter.pauseCommand.addTarget { [weak self] _ in
          self?.player?.pause()
          return .success
      }
      
      commandCenter.togglePlayPauseCommand.addTarget { [weak self] _ in
          if self?.player?.rate == 0 {
              self?.player?.play()
          } else {
              self?.player?.pause()
          }
          return .success
      }
      
      commandCenter.nextTrackCommand.addTarget { [weak self] _ in
          self?.channel?.invokeMethod("onNextTrack", arguments: nil)
          return .success
      }
      
      commandCenter.previousTrackCommand.addTarget { [weak self] _ in
          self?.channel?.invokeMethod("onPreviousTrack", arguments: nil)
          return .success
      }
  }
  
  private func updateNowPlayingInfo(title: String, artist: String) {
      var nowPlayingInfo = [String: Any]()
      
      nowPlayingInfo[MPMediaItemPropertyTitle] = title
      nowPlayingInfo[MPMediaItemPropertyArtist] = artist
      
      if let duration = playerItem?.duration.seconds {
          nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration
      }
      
      if let currentTime = playerItem?.currentTime().seconds {
          nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
      }
      
      // Add playback rate
      nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player?.rate ?? 0
      
      // Add artwork if available
      // let artwork = MPMediaItemArtwork(boundsSize: CGSize(width: 100, height: 100)) { [weak self] _ in
      //     if let imageUrlString = self?.artworkUrl,
      //        let imageUrl = URL(string: imageUrlString),
      //        let imageData = try? Data(contentsOf: imageUrl),
      //        let image = UIImage(data: imageData) {
      //         return image
      //     }
      //     return UIImage(named: "AppIcon") ?? UIImage()
      // }
      // nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
      
      // Set the now playing info
      MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
      
      // Enable remote control events
      UIApplication.shared.beginReceivingRemoteControlEvents()
  }

  private func setFilePath(filePath: String, result: @escaping FlutterResult) {
      cleanup()
      guard let url = URL(string: filePath) else {
          result(FlutterError(code: "INVALID_ARGUMENTS",
                            message: "Invalid file path provided",
                            details: nil))
          return
      }
      player = AVPlayer(url: url)
      
      // Get metadata from the asset
      let asset = AVAsset(url: url)
      let metadata = asset.metadata
      
      // Extract title and artist from metadata
      var title = ""
      var artist = ""
      
      for item in metadata {
          if item.commonKey == AVMetadataKey.commonKeyTitle {
              title = item.stringValue ?? ""
          } else if item.commonKey == AVMetadataKey.commonKeyArtist {
              artist = item.stringValue ?? ""
          }
      }
      
      nowPlayingInfo[MPMediaItemPropertyTitle] = title
      nowPlayingInfo[MPMediaItemPropertyArtist] = artist
      
      result(nil)
  }
  
  private func play(url: URL, result: @escaping FlutterResult) {
    cleanup()
    playerItem = AVPlayerItem(url: url)
    player = AVPlayer(playerItem: playerItem)

    // Add completion observer
    NotificationCenter.default.addObserver(
        self,
        selector: #selector(playerDidFinishPlaying),
        name: .AVPlayerItemDidPlayToEndTime,
        object: playerItem
    )

    // Observe player status
    observePlayerStatus(updatedStatus: "playing")

    player?.play()
    startPositionTimer()
    setupAudioSession()
    
    // Update now playing info immediately after starting playback
    updateNowPlayingInfo(
        title: nowPlayingInfo[MPMediaItemPropertyTitle] as? String ?? "",
        artist: nowPlayingInfo[MPMediaItemPropertyArtist] as? String ?? ""
    )
    
    result(nil)
  }
  
  private func pause(result: @escaping FlutterResult) {
      player?.pause()
      observePlayerStatus(updatedStatus: "paused")
      updateNowPlayingInfo(
          title: nowPlayingInfo[MPMediaItemPropertyTitle] as? String ?? "",
          artist: nowPlayingInfo[MPMediaItemPropertyArtist] as? String ?? ""
      )
      result(nil)
  }
  
  private func resume(result: @escaping FlutterResult) {
      player?.play()
      observePlayerStatus(updatedStatus: "playing")
      updateNowPlayingInfo(
          title: nowPlayingInfo[MPMediaItemPropertyTitle] as? String ?? "",
          artist: nowPlayingInfo[MPMediaItemPropertyArtist] as? String ?? ""
      )
      result(nil)
  }
  
  private func stop(result: @escaping FlutterResult) {
      cleanup()
      observePlayerStatus(updatedStatus: "stopped")
      result(nil)
  }
  
  private func getCurrentPosition(result: @escaping FlutterResult) {
      guard let player = player else {
          result(FlutterError(code: "PLAYER_ERROR",
                            message: "Player is not initialized",
                            details: nil))
          return
      }
      let currentTime = player.currentTime().seconds
      result(Int(currentTime * 1000))
  }
  
  private func seekTo(position: Int, result: @escaping FlutterResult) {
      guard let player = player else {
          result(FlutterError(code: "PLAYER_ERROR",
                            message: "Player is not initialized",
                            details: nil))
          return
      }
      let newStatus = status == "ready" || status == "stopped" ? "paused" : status
      observePlayerStatus(updatedStatus: newStatus)
      let timeInSeconds = Double(position)
      player.seek(to: CMTime(seconds: timeInSeconds, preferredTimescale: 600))

      result(nil)
  }
  
  private func getDuration(result: @escaping FlutterResult) {
      guard let player = player else {
          result(FlutterError(code: "PLAYER_ERROR",
                            message: "Player is not initialized",
                            details: nil))
          return
      }
      let duration = CMTimeGetSeconds(player.currentItem?.asset.duration ?? CMTime.zero)
      result(Int(duration * 1000)) // Convert to milliseconds
  }
  
  private func startPositionTimer() {
      guard let player = player else { return }
      stopPositionTimer()
      timeObserverToken = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: 600), queue: .main) { [weak self] time in
          let position = Int(time.seconds * 1000)
          self?.channel?.invokeMethod("onPositionChanged", arguments: position)
          
          // Update now playing info with current position
          self?.updateNowPlayingInfo(
              title: self?.nowPlayingInfo[MPMediaItemPropertyTitle] as? String ?? "",
              artist: self?.nowPlayingInfo[MPMediaItemPropertyArtist] as? String ?? ""
          )
      }
  }
  
  private func stopPositionTimer() {
      if let token = timeObserverToken {
          player?.removeTimeObserver(token)
          timeObserverToken = nil
      }
  }
  
  private func setupAudioSession() {
      do {
          let session = AVAudioSession.sharedInstance()
          try session.setCategory(.playback, mode: .default, options: [.allowBluetooth, .mixWithOthers])
          try session.setActive(true, options: .notifyOthersOnDeactivation)
          
          // Enable background audio
          UIApplication.shared.beginReceivingRemoteControlEvents()
          
          // Configure audio session for background playback
          try session.setActive(true)
      } catch {
          print("Failed to set up audio session: \(error)")
      }
  }

    @objc func playerDidFinishPlaying(note: NSNotification) {
        logPlayerState()
        // Ensure we're on the main thread
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Stop the player
            self.player?.pause()
            
            // Reset position
            self.player?.seek(to: .zero)
            observePlayerStatus(updatedStatus: "completed")
            // Notify Dart
            self.channel?.invokeMethod("onPlaybackComplete", arguments: nil)

            print("onPlaybackComplete invoked on channel")
        }
    }

    private func logPlayerState() {
        print("Player State:")
        print("- Player exists: \(player != nil)")
        print("- Player item exists: \(playerItem != nil)")
        if let player = player {
            print("- Current time: \(player.currentTime().seconds)")
            print("- Rate: \(player.rate)")
        }
        if let playerItem = playerItem {
            print("- Duration: \(playerItem.duration.seconds)")
            print("- Status: \(playerItem.status.rawValue)")
        }
    }

    private func observePlayerStatus(updatedStatus: String) {
        statusObserver?.invalidate()
        status = updatedStatus
        self.channel?.invokeMethod("onStatusChanged", arguments: updatedStatus)
    }

}
