import SwiftUI

extension Font {
    static func googleSansFlex(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return .custom("GoogleSansFlex-Regular", size: size)
    }
    
    static func dynaPuff(size: CGFloat) -> Font {
        return .custom("DynaPuff-VariableFont_wdth,wght", size: size)
    }
}

extension View {
    func googleSansFont(size: CGFloat, weight: Font.Weight = .regular) -> some View {
        self.font(.googleSansFlex(size: size, weight: weight))
    }
    
    func dynaPuffFont(size: CGFloat) -> some View {
        self.font(.dynaPuff(size: size))
    }
}
