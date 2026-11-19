import SwiftUI
struct VirtualJoystick: View {
    @Binding var value: SIMD2<Float>
    @State private var knob = CGSize.zero
    var body: some View {
        GeometryReader { geo in let side=min(geo.size.width,geo.size.height)
            ZStack { Circle().fill(.black.opacity(0.45)).overlay(Circle().stroke(.white.opacity(0.35),lineWidth:1)); Circle().fill(.white.opacity(0.22)).frame(width:side*0.38,height:side*0.38).offset(knob) }
                .frame(width:side,height:side).gesture(DragGesture(minimumDistance:0).onChanged { p in let center=CGPoint(x:side/2,y:side/2); let dx=p.location.x-center.x, dy=p.location.y-center.y; let radius=side*0.29; let length=max(1,hypot(dx,dy)); let x=dx/length*min(length,radius), y=dy/length*min(length,radius); knob=CGSize(width:x,height:y); value=SIMD2(Float(x/radius),Float(y/radius)) }.onEnded { _ in knob = .zero; value = .zero })
        }
    }
}
