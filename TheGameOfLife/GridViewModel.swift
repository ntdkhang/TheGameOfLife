//
//  GridViewModel.swift
//  TheGameOfLife
//
//  Created by Nguyen Tran Duy Khang on 12/13/21.
//

import SwiftUI
import Foundation

class GridViewModel: ObservableObject {
    @Published var grid: [[Cell]] // the grid uses the index that is equivalent to the coordination system
    // with (0,0) at top left and (width - 1, height - 1) at bottom right
    private(set) var oneSquareLength: Int = 30
    private(set) var width: Int = 0
    private(set) var height: Int = 0
    private var screenSize: CGSize = .zero
    
    // MARK: - Performing operations on squares
    func nextIteration() {
        // Iterate over every cell and check if it will live or die
        for indexY in 0..<height {
            for indexX in 0..<width {
                if willYouLive(cell: grid[indexX][indexY]) == true {
                    grid[indexX][indexY].state = .on
                } else {
                    grid[indexX][indexY].state = .off
                }
            }
        }
    }
    
    
    // True -> live, false -> die
    private func willYouLive(cell: Cell) -> Bool {
        // if live && (has 2 or 3 neighbors) -> stays alive
        // else if dead && has 3 neighbors -> alive
        // else dead
        let neighborCount = countNeighborFor(cell: cell)
        if (cell.state == .on && (2...3).contains(neighborCount)) {
            return true
        } else if (cell.state == .off && neighborCount == 3) {
            return true
        } else {
            return false
        }
    }
    
    private func countNeighborFor(cell: Cell) -> Int {
        /*
      (0,0)
         _______
        |       |
        |     * | (5,1)
        |       |
        |       |
        |       |
         -------
              (6,4)
         */
        
        // Normal case
        // is west
        // is east
        // is north
        // is south
        // is north west
        // is north east
        // is south east
        // is south west
        
//        let countNeighbors: Int = {
//            Int(isWestNeighbor(cell: cell)) + Int(isEastNeighbor(cell: cell)) +
//            Int(isNorthNeighbor(cell: cell)) +
//            Int(isSouthNeighbor(cell: cell)) +
//            Int(isNorthWestNeighbor(cell: cell)) +
//            Int(isNorthEastNeighbor(cell: cell)) +
//            Int(isSouthEastNeighbor(cell: cell)) +
//            Int(isSouthWestNeighbor(cell: cell))
//        }()
        var countNeighbors = 0
        if (isWestNeighbor(cell: cell)) { countNeighbors += 1 }
        if (isEastNeighbor(cell: cell)) { countNeighbors += 1 }
        if (isNorthNeighbor(cell: cell)) { countNeighbors += 1 }
        if (isSouthNeighbor(cell: cell)) { countNeighbors += 1 }
        if (isNorthWestNeighbor(cell: cell)) { countNeighbors += 1 }
        if (isNorthEastNeighbor(cell: cell)) { countNeighbors += 1 }
        if (isSouthEastNeighbor(cell: cell)) { countNeighbors += 1 }
        if (isSouthWestNeighbor(cell: cell)) { countNeighbors += 1 }
        
        return countNeighbors
    }
    
    private func isSouthWestNeighbor(cell: Cell) -> Bool {
        if (cell.indexX > 0 && cell.indexY < self.height - 1) {
            return grid[cell.indexX - 1][cell.indexY + 1].state == .on
        }
        return false
    }
    
    private func isSouthEastNeighbor(cell: Cell) -> Bool {
        if (cell.indexX < self.width - 1 && cell.indexY < self.height - 1) {
            return grid[cell.indexX + 1][cell.indexY + 1].state == .on
        }
        return false
    }
    
    private func isNorthEastNeighbor(cell: Cell) -> Bool {
        if (cell.indexX < self.width - 1 && cell.indexY > 0) {
            return grid[cell.indexX + 1][cell.indexY - 1].state == .on
        }
        return false
    }
    
    private func isNorthWestNeighbor(cell: Cell) -> Bool {
        if (cell.indexY > 0 && cell.indexX > 0) {
            return grid[cell.indexX - 1][cell.indexY - 1].state == .on
        }
        return false
    }
    
    private func isSouthNeighbor(cell: Cell) -> Bool {
        if (cell.indexY < self.height - 1) {
            return grid[cell.indexX][cell.indexY + 1].state == .on
        }
        return false
    }
    
    private func isNorthNeighbor(cell: Cell) -> Bool {
        if (cell.indexY > 0) {
            return grid[cell.indexX][cell.indexY - 1].state == .on
        }
        return false
    }
    
    private func isWestNeighbor(cell: Cell) -> Bool {
        if (cell.indexX > 0) {
            return grid[cell.indexX - 1][cell.indexY].state == .on
        }
        return false
    }
    
    private func isEastNeighbor(cell: Cell) -> Bool {
        if (cell.indexX < self.width - 1) {
            return grid[cell.indexX + 1][cell.indexY].state == .on
        }
        return false
    }
    
    
    
    // MARK: - Drawing Grid
    
    private func getGridOriginal(screenSize: CGSize) -> CGPoint {
        let xVal = (Int(screenSize.width) % oneSquareLength) / 2
        let yVal = (Int(screenSize.height) % oneSquareLength) / 2
        return CGPoint(x: xVal, y: yVal)
    }
    
    private func getGridWidth(size: CGSize) -> Int {
        return Int(size.width) / oneSquareLength
    }
    
    private func getGridHeight(size: CGSize) -> Int {
        return Int(size.height) / oneSquareLength
    }
    
    private func getRectAtCoordinate(x: Int, y: Int) -> CGRect {
        CGRect(x: x, y: y, width: oneSquareLength, height: oneSquareLength)
    }
    
     func recalibrateScreenSize(size: CGSize) {
        if self.screenSize != size {
            self.screenSize = size
            self.width = getGridWidth(size: size)
            self.height = getGridHeight(size: size)
            
            fillGridRandomly()
        }
    }
    
    
    func getSquarePathAtIndex(x: Int, y: Int, screenSize: CGSize) -> Path {
        recalibrateScreenSize(size: screenSize)
        let original = getGridOriginal(screenSize: screenSize)
        let posX: Int = Int(original.x) + x * oneSquareLength
        let posY: Int = Int(original.y) + y * oneSquareLength
        return Path(roundedRect: getRectAtCoordinate(x: posX, y: posY),
             cornerRadius: 0)
    }
    
    
    private func fillGridRandomly() {
        grid = [[Cell]]()
        for indexX in 0..<width {
            grid.append([Cell]())
            for indexY in 0..<height {
                let randomInt = Int.random(in: 0...1)
                let state = randomInt == 0 ? Cell.State.off : Cell.State.on
                grid[indexX].append(Cell(indexX: indexX, indexY: indexY, state: state))
            }
        }
    }
    
    init() {
        grid = [[Cell]]()
        self.width = 0
        self.height = 0
        self.screenSize = .zero
        fillGridRandomly()
        
    }
    
}

struct Cell {
    var state: State = .off
    var indexX: Int
    var indexY: Int
    
    enum State: Int {
        case on = 1
        case off = 0
    }
    
    
}

extension Cell {
    init(indexX: Int, indexY: Int, state: State) {
        self.state = state
        self.indexX = indexX
        self.indexY = indexY
    }
}






