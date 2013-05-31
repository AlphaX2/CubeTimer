import bb.cascades 1.0

SceneCover {
    // The content property must be explicitly specified
    content: Container {

        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill

        background: Color.create("#0098f0")
        layout: DockLayout {}
        
        Container {

            horizontalAlignment: HorizontalAlignment.Center

            ImageView {
                imageSource: "asset:///images/cube_bg.png"
                preferredWidth: 200
                preferredHeight: 200
                opacity: 0.60
            }
        }
        
        Container {

            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Bottom

            Label {
                text: "record:"
                textStyle.fontWeight: FontWeight.Bold
                textStyle.fontSize: FontSize.Medium
                textStyle.color: Color.create("#f8f8f8")
            }

            Label {
                text: rubikTimer.bestTimeString
                textStyle.fontWeight: FontWeight.W100
                textStyle.fontSize: FontSize.XXLarge
                textStyle.color: Color.create("#f8f8f8")
            }
        }
    }
}