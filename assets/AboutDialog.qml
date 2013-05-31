import bb.cascades 1.0

Dialog {
    Container {    
	    layout: DockLayout {}
	    
	    background: Color.Black
	    //opacity: 0.90

        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill

        Container {
        	layout: DockLayout{}
        	
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
            
            Container {
                layout: StackLayout {}
                
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center

                Label {
				    text: "CubeTimer"
				    
		            textStyle.fontSize: FontSize.XXLarge
		            textStyle.fontWeight: FontWeight.W100
		            textStyle.color: Color.create("#f8f8f8")
	                horizontalAlignment: HorizontalAlignment.Left
		        }
	            Label {
	                
	                topPadding: 30
	                leftPadding: 30
	                rightPadding: 30
	                
	                text: "CubeTimer is an application created for everyone, who wants to train the cube solving skills. You get random scramble command you can scramble your cube with, and than you can stop the time you need to solve the cube.\nYour best, last and average time are saved. So you can train to become better or you share your records with friends!\n\r\nAuthor: Gabriel Böhme\n\r\nMail: m.gabrielboehme@googlemail.com\n\r\nLicence: GNU General Public Licence 3 \n\nCode: github.com/AlphaX2/CubeTimer\n\nVersion: 1.1.0"
	
	                textStyle.fontSize: FontSize.Small
	                textStyle.color: Color.create("#f8f8f8")
	                textStyle.fontWeight: FontWeight.W100
	                multiline: true
	            }
	        
		        Container {
		            layout: StackLayout{
		                orientation: LayoutOrientation.LeftToRight
	                }
		            
					topMargin: 50
	                horizontalAlignment: HorizontalAlignment.Center
	               
	               	Button {
	                    text: "Okay"
	                    onClicked: {
	                        close()
	                    }
	                }   
		        }
		    }
	    }
	}
}
