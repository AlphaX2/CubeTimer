import bb.cascades 1.0

SceneCover {
    // The content property must be explicitly specified
    content: Container {
        
        background: Color.create("#0098f0")
        layout: DockLayout {}
        
        Container {

            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center

			ImageView {
			    imageSource: "asset:///images/cube_bg.png"
			    preferredWidth: 320	
			    preferredHeight: 320
            }

        }
        
        Container {
            horizontalAlignment: HorizontalAlignment.Left
            verticalAlignment: VerticalAlignment.Top

            Label {

                leftMargin: 20
                leftPadding: 20

                text: "record:"
                textStyle.fontWeight: FontWeight.Bold
                textStyle.fontSize: FontSize.Medium
                textStyle.color: Color.create("#f8f8f8")
            }
        }
        
        Container {

            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Bottom

            Label {
                text: rubikTimer.bestTimeString
                textStyle.fontWeight: FontWeight.W100
                textStyle.fontSize: FontSize.XXLarge
                textStyle.color: Color.create("#f8f8f8")
            }
        }
    }
}