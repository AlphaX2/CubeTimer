import bb.cascades 1.0
import bb.system 1.0

Dialog {

    attachedObjects: [
        SystemToast {
            id: resetToast
            body: "Your data has been successfully reset!"
            icon: "images/ic_delete.png"
        }
    ]

    Container {    
	    layout: DockLayout {}
	    
	    background: Color.Black
	    opacity: 0.90

        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
        Container {
        	layout: StackLayout{}
        	
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center

            Label {
			    text: "Warning"
			    
	            textStyle.fontSize: FontSize.XXLarge
	            textStyle.fontWeight: FontWeight.W100
	            textStyle.color: Color.Red
                horizontalAlignment: HorizontalAlignment.Left
	        }
            Label {
                
                topPadding: 30
                leftPadding: 30
                rightPadding: 30
                
                text: "Do you want reset all application data? Also record and average times?"
                textStyle.fontSize: FontSize.Large
                textStyle.color: Color.create("#f8f8f8")
                multiline: true
            }
        
	        Container {
	            layout: StackLayout{
	                orientation: LayoutOrientation.LeftToRight
                }
	            
				topMargin: 50
                horizontalAlignment: HorizontalAlignment.Center
               
               	Button {
                    text: "Cancel"
                    onClicked: {
                        close()
                    }
                }
                Button {
	                text: "Delete"
                    onClicked: {
                        rubikTimer.resetData()
                    	resetToast.show()
                    	close()
                    }
	            }    
	        }
	    }
	}
}
