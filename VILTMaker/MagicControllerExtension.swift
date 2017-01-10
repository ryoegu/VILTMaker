//
//  MagicControllerExtension.swift
//  VILTMaker
//
//  Created by Ryo Eguchi on 2017/01/08.
//  Copyright © 2017年 Ryo Eguchi. All rights reserved.
//


import UIKit
import MultipeerConnectivity

extension ViewController: MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate {
    
    func setupSession() {
        peerID = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: peerID)
        session.delegate = self
        
        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "sampler20170823")
        advertiser?.delegate = self
        advertiser?.startAdvertisingPeer()
        
        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: "sampler20170823")
        browser.delegate = self;
        browser.startBrowsingForPeers()
    }
    
    func sendData() {
        if session.connectedPeers.count > 0 {
            do {
                let data = "RECEIVED".data(using: String.Encoding.utf8)
                try session.send(data!, toPeers: session.connectedPeers, with: .reliable)
            } catch let error as NSError {
                let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(ac, animated: true, completion: nil)
            }
        }
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            DispatchQueue.main.async {
                self.statusLabel.textColor = UIColor.green
            }
            
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            DispatchQueue.main.async {
                self.statusLabel.textColor = UIColor.yellow
            }
            
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
            DispatchQueue.main.async {
                self.statusLabel.textColor = UIColor.red
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let str = String(data: data, encoding: String.Encoding.utf8)
        //※point!!（非同期なのでpromiseで認知してあげる必要がある.）
        
        DispatchQueue.main.async {
            self.statusLabel.textColor = UIColor.green
            print("相手からのdata : \(str!)")
            
            switch str! {
            case "UP":
                self.upSwipe()
            case "DOWN":
                self.downSwipe()
            case "RIGHT":
                self.rightSwipe()
            case "LEFT":
                self.leftSwipe()
            case "ONETAP":
                self.oneTapGesture()
            default:
                break
            }
            
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
    }
    
    func browserViewController(_ browserViewController: MCBrowserViewController, shouldPresentNearbyPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) -> Bool {
        return true
    }
    
    //    Peer を発見した際に呼ばれるメソッド
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?){
        
        DispatchQueue.main.async {
            self.statusLabel.textColor = UIColor.yellow
        }
        
        print("peer discovered")
        print("device : \(peerID.displayName)")
        //発見した Peer へ招待を送る
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 0)
    }
    
    //    Peer を見失った際に呼ばれるメソッド
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("peer lost")
        DispatchQueue.main.async {
            self.statusLabel.textColor = UIColor.red
        }
        
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        //招待を受けるかどうかと自身のセッションを返す
        invitationHandler(true, session)
        
    }
    

  }
