//
//  GameBoardView.swift
//  Connect4
//
//  Created by 宋文迪 on 30/11/2022.
//

import UIKit

class Connect4View: UIView {
    var boardWidth: CGFloat {return UIScreen.main.bounds.size.width}
    var boardHeight: CGFloat {return UIScreen.main.bounds.size.width/7*6}
    var boardCenter: CGPoint { return convert(center, from: superview) }
    
    override func draw(_ rect: CGRect) {
        drawGameBoard()
    }
    private func drawGameBoard() {
        let boardPath = UIBezierPath(roundedRect: CGRect(x:0,y:boardCenter.y - boardHeight/2,width:boardWidth, height:boardHeight),cornerRadius: 1)
        boardPath.stroke()
        boardPath.fill()
    }
}
