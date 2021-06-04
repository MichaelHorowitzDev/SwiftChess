//
//  ChessBoard.swift
//  Chess SwiftUI
//
//  Created by Michael Horowitz on 5/6/21.
//

import SwiftUI
import SwiftChess
struct ChessBoard: View {
    @StateObject private var viewModel: ChessViewModel
    @State var alertPresented = false
    let lightColor: Color
    let darkColor: Color
    init(lightColor: Color, darkColor: Color, game: Game) {
        self.lightColor = lightColor
        self.darkColor = darkColor
        self._viewModel = StateObject(wrappedValue: ChessViewModel(game: game))
    }
    @State var highlighted: Int?
    var body: some View {
        ZStack {
            if alertPresented {
                TextFieldAlert(title: "Fen", message: nil, isPresented: $alertPresented) { fen in
                    viewModel.fen = fen
                }
                .zIndex(1)
            }
            if viewModel.promotionSelection {
                PromotionSelection(color: viewModel.game.turn, promotionPiece: $viewModel.promotionPiece)
                    .zIndex(1)
            }
            VStack {
                Group {
                    if viewModel.game.gameState == .playing {
                        Text("Playing")
                    } else if viewModel.game.gameState == .check {
                        Text("Check")
                    } else if viewModel.game.gameState == .checkmate {
                        Text("Checkmate")
                    } else if viewModel.game.gameState == .stalemate {
                        Text("Stalemate")
                    } else if viewModel.game.gameState == .moveRule {
                        Text("50 Move Rule")
                    } else if viewModel.game.gameState == .repetition {
                        Text("3 Fold Repetition")
                    }
                    Spacer()
                }
            }
            .font(.title.bold())
            .padding(.top, 50)
            VStack(spacing: 0) {
                ForEach(0..<viewModel.game.board.board.count) { rank in
                    HStack(spacing: 0) {
                        ForEach(0..<viewModel.game.board.board[rank].count) { item in
                            Tile(rank: rank, item: item, piece: viewModel.game.board.board.reversed()[rank][item], lightColor: lightColor, darkColor: darkColor, id: (item, viewModel.game.board.board.count-1-rank), selectedPiece: $viewModel.selectedPiece, highlightedPieces: viewModel.highlightedPieces, attackedSquares: viewModel.attackedSquares)
                        }
                    }
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .padding()
            VStack {
                Spacer()
                HStack {
                    Button("Undo") {
                        viewModel.game.undoMove()
                        viewModel.selectedPiece = nil
                    }
                    Spacer()
                    Button("Load FEN") {
                        self.alertPresented = true
                    }
                }
                .padding(30)
            }
        }
        .alert(isPresented: $viewModel.invalidFen) {
            Alert(title: Text("Invalid FEN"))
        }
    }
}

struct TextFieldAlert: View {
    let title: String
    let message: String?
    var textFieldPlaceholder = "FEN"
    @State var text = ""
    @Binding var isPresented: Bool
    let fen: (String) -> Void
    var body: some View {
        VStack {
            Text(title)
                .bold()
            Text(message ?? "")
                .font(.body)
            TextField(textFieldPlaceholder, text: $text)
                .padding(.leading, 1)
                .padding(1)
                .border(Color(.black), width: 1)
                .padding()
            HStack {
                Spacer()
                Button {
                    isPresented = false
                } label: {
                    Text("Cancel")
                        .foregroundColor(.blue)
                        .bold()
                }
                Spacer()
                Button {
                    isPresented = false
                    fen(text)
                } label: {
                    Text("OK")
                        .foregroundColor(.blue)
                        .bold()
                }
                Spacer()
            }
        }
        .frame(width: 250, height: 140, alignment: .center)
        .background(RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color(red: 244.0/256, green: 250.0/256, blue: 238.0/256, opacity: 0.999)))
    }
}

struct Tile: View {
    let rank: Int
    let item: Int
    let piece: Piece?
    let lightColor: Color
    let darkColor: Color
    let id: (Int, Int)
    @Binding var selectedPiece: (Int, Int)?
    let highlightedPieces: [(Int, Int)]
    let attackedSquares: [(Int, Int)]
    var body: some View {
        ZStack {
            Group {
                if highlightedPieces.contains {$0 == id} {
                    Color(.yellow)
                }
                else if (item + rank)%2 == 0 {
                    lightColor
                } else {
                    darkColor
                }
            }
            if selectedPiece ?? (100, 100) == id {
                Rectangle()
                    .foregroundColor(Color.clear)
                    .padding(4)
                    .border(Color.green, width: 4)
            }
            if piece != nil {
                if piece!.color == .white {
                    switch piece {
                    case is Pawn:
                        Image("pawn_white")
                    case is Rook:
                        Image("rook_white")
                    case is Bishop:
                        Image("bishop_white")
                    case is Queen:
                        Image("queen_white")
                    case is King:
                        Image("king_white")
                    case is Knight:
                        Image("knight_white")
                    default:
                        EmptyView()
                    }
                } else {
                    switch piece {
                    case is Pawn:
                        Image("pawn_black")
                    case is Rook:
                        Image("rook_black")
                    case is Bishop:
                        Image("bishop_black")
                    case is Queen:
                        Image("queen_black")
                    case is King:
                        Image("king_black")
                    case is Knight:
                        Image("knight_black")
                    default:
                        EmptyView()
                    }
                }
            }
        }
        .onTapGesture {
            if selectedPiece == nil {
                selectedPiece = id
            } else {
                if selectedPiece! == id {
                    selectedPiece = nil
                } else {
                    selectedPiece = id
                }
            }
        }
    }
}

struct PromotionSelection: View {
    var color: PieceColor
    @Binding var promotionPiece: Promotion
    var body: some View {
        if color == .white {
            HStack {
                Button {
                    self.promotionPiece = .queen
                } label: {
                    Image("queen_white")
                }
                Button {
                    self.promotionPiece = .rook
                } label: {
                    Image("rook_white")
                }
                Button {
                    self.promotionPiece = .bishop
                } label: {
                    Image("bishop_white")
                }
                Button {
                    self.promotionPiece = .knight
                } label: {
                    Image("knight_white")
                }
            }
            .padding(50)
            .background(RoundedRectangle(cornerRadius: 25)
                            .foregroundColor(.white))
        } else {
            HStack {
                Button {
                    self.promotionPiece = .queen
                } label: {
                    Image("queen_black")
                }
                Button {
                    self.promotionPiece = .rook
                } label: {
                    Image("rook_black")
                }
                Button {
                    self.promotionPiece = .bishop
                } label: {
                    Image("bishop_black")
                }
                Button {
                    self.promotionPiece = .knight
                } label: {
                    Image("knight_black")
                }
            }
            .padding(50)
            .background(RoundedRectangle(cornerRadius: 25)
                            .foregroundColor(.white))
        }
    }
}

struct ChessBoard_Previews: PreviewProvider {
    static var previews: some View {
        ChessBoard(lightColor: Color(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)), darkColor: Color(#colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)), game: Game())
    }
}
