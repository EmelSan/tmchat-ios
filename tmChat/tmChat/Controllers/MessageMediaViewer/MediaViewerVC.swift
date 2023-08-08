//
//  MediaViewerVC.swift
//  tmchat
//
//  Created by Shirin on 4/13/23.
//

import UIKit
import EasyPeasy
import AVFoundation
import Alamofire

class MediaViewerVC: UIViewController {

    var index: Int!
    var data: Message!
    
    var content = UIImageView(contentMode: .scaleAspectFit,
                              cornerRadius: 10,
                              image: nil,
                              backgroundColor: .black)
    
    var progress = CustomProgressView(colors: [.white], lineWidth: 4, bgColor: .clear)
    
    var playerView = UIView()

    var player: AVPlayer?
    var asset: AVAsset?
    
    var didSetup = false
    var didAppear = false
    
    var timeObserver: Any?
    var currentTime: Double? {
        didSet {
            updateSliderValue?()
        }
    }
    
    var onDidAppear: ( ()->() )?
    var updateSliderValue: ( ()->() )?
    var footer: MediaViewerFooter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        didAppear = true
        onDidAppear?()
        footer.setupPlayIcon(isPlaying: player?.isPlaying)
        setupCallbacks()
//        player?.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        didAppear = false
        player?.pause()
    }

    deinit {
        guard let o = timeObserver else { return }
        player?.removeTimeObserver(o)
    }
    
    func setupView(){
        view.addSubview(content)
        content.easy.layout([
            Top().to(view.safeAreaLayoutGuide, .top),
            Bottom().to(view.safeAreaLayoutGuide, .bottom),
            Leading(1),
            Trailing(1),
        ])
        
        view.addSubview(progress)
        progress.easy.layout([
            Center(), Size(60)
        ])
    }
    
    func setupData(){
        if didSetup { return }
        didSetup = true
        if data.type == MsgType.video.rawValue {
            content.addSubview(playerView)
            playerView.easy.layout(Edges())
            downloadFile(filename: data.content, url: data.fileUrl ?? "")
            
        } else {
        
            if (data.fileUrl ?? "").isEmpty {
                content.kf.setImage(with: URL(fileURLWithPath: data.localPath ?? ""))
            } else {
                content.kf.setImage(with: URL(string: data.fileUrl ?? ""))
            }
            playerView.removeFromSuperview()
        }
    }
    
    func setupCallbacks(){
        footer.pauseBtn.clickCallback = { [weak self] in
            if self?.player?.isPlaying == true {
                self?.player?.pause()
            } else {
                self?.player?.play()
            }
            
            self?.footer.setupPlayIcon(isPlaying: self?.player?.isPlaying)
        }
    }
    
    private func addVideoPlayer(with asset: AVAsset, playerView: UIView) {
        let playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)

        NotificationCenter.default.addObserver(self, selector: #selector(self.itemDidFinishPlaying(_:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)

        let layer: AVPlayerLayer = AVPlayerLayer(player: player)
        layer.backgroundColor = UIColor.black.cgColor
        layer.frame = CGRect(x: 0,
                             y: 0,
                             width: DeviceDimensions.width,
                             height: DeviceDimensions.safeAreaHeight)
        
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerView.layer.sublayers?.forEach({$0.removeFromSuperlayer()})
        playerView.layer.addSublayer(layer)
        observers()
        if !didAppear {
            player?.play()
        }
    }
    
    @objc func itemDidFinishPlaying(_ notification: Notification) {
        currentTime = 0
        player?.seek(to: .zero)
    }
    
    func observers(){
        timeObserver = player?.addPeriodicTimeObserver(forInterval: .init(seconds: 0.01, preferredTimescale: 1_000), queue: .main) { [weak self] time in
            guard let self = self else { return }
            self.currentTime = time.seconds
        }
    }

    func downloadFile(filename: String, url: String) {
        progress.isAnimating = true

        let destinationUrl = FileManager.default.getDocDir()
                                        .appendingPathComponent(filename)

        if FileManager().fileExists(atPath: destinationUrl.path) {
            progress.isAnimating = false
            let asset = AVAsset(url: destinationUrl)
            addVideoPlayer(with: asset, playerView: playerView)
        } else {
            
            let destination: DownloadRequest.Destination = { _, _ in
                return (destinationUrl, [.removePreviousFile,
                                         .createIntermediateDirectories])
            }

            AF.download(URL(string: url)!, to: destination).response { response in
                self.progress.isAnimating = false
                if response.error == nil {
                    let asset = AVAsset(url: destinationUrl)
                    self.addVideoPlayer(with: asset, playerView: self.playerView)
                }
            }
        }
    }
}

