import SwiftUI

extension Font {
    static func googleSansFlex(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return .custom("GoogleSansFlex-Regular", size: size)
    }
}

extension View {
    func googleSansFont(size: CGFloat, weight: Font.Weight = .regular) -> some View {
        self.font(.googleSansFlex(size: size, weight: weight))
    }
}
