import bb.cascades 1.0

Page {
    
    titleBar: TitleBar {
        id: titleBarSettings
        
        title: "CubeTimer | Settings"
    }
    paneProperties: NavigationPaneProperties {
        backButton: ActionItem {
            title: "Back"
            onTriggered: {
                rubikTimer.saveSettings(stopwatch_checkbox.checked, inspection_checkbox.checked, inspect_slider.value);
                navigationPane.pop()
            }
        }
    }
    
    attachedObjects: [
        ResetDialog {
            id: resetDialog
        }
    ]

    Container {
        id: content

        horizontalAlignment: HorizontalAlignment.Fill
        background: Color.create("#262626")

        layout: StackLayout {}
        
        rightPadding: 20
        leftPadding: 20
        topPadding: 30

        Container {
            
            topPadding: 50
            
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }

            horizontalAlignment: HorizontalAlignment.Left

            CheckBox {
                id: stopwatch_checkbox
                topMargin: 75
                leftPadding: 30
                checked: rubikTimer.stopwatchMode
                preferredHeight: 150
                preferredWidth: 150
            }
            Label {
                leftMargin: 30
                text: "Stopwatch"
                textStyle.color: Color.create("#f8f8f8")
                textStyle.fontSize: FontSize.Large
            }
        }
        Container {     
            
            topPadding: 75
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            
            horizontalAlignment: HorizontalAlignment.Left

            CheckBox {
	            id: inspection_checkbox
                leftPadding: 30
                checked: rubikTimer.inspectionMode
                preferredHeight: 150
                preferredWidth: 150
            }
            Label {
                leftMargin: 30
                text: "Inspection (seconds)"
                textStyle.color: Color.create("#f8f8f8")
                textStyle.fontSize: FontSize.Large
            }
        }
        
        Container {
            id: sliderTools

            topPadding: 50

            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            Slider {
                id: inspect_slider

                preferredWidth: 650.0
                maxWidth: 650.0

                enabled: inspection_checkbox.checked ? true : false
                opacity: inspection_checkbox.checked ? 1.0 : 0.5

                fromValue: 5
            	toValue: 60
            	
            	value: rubikTimer.inspectionTime
            	
            	onImmediateValueChanged: {
                    //prevent XX.xxxxxxxxxxxx nums
                    sliderValue.text = ~~immediateValue
                }
            }
            Label {
                id: sliderValue

                enabled: inspection_checkbox.checked ? true : false
                opacity: inspection_checkbox.checked ? 1.0 : 0.5
                
                text: "0"
                textStyle.fontSize: FontSize.Large
                textStyle.color: Color.create("#f8f8f8")
            }
        }    
        Container {
            topPadding: 200
            horizontalAlignment: HorizontalAlignment.Center
            
            // There is no color option for a divider so use a container
            Container {
                preferredHeight: 2
                preferredWidth: 800
            	background: Color.create("#f4f4f4")
                horizontalAlignment: HorizontalAlignment.Fill
            }
            
            Button {
                topMargin: 100
            	text: "Reset application"
                horizontalAlignment: HorizontalAlignment.Center
                
                onClicked: {
                    // NEED safety dialog here!
                    resetDialog.open()
                }
            }
        }
    }
    onCreationCompleted: {
        rubikTimer.loadSettings();
    }
}
