import bb.cascades 1.0
import bb.system 1.0
import qt.qtimer 1.0

NavigationPane {
    id: navigationPane
    
    attachedObjects: [
        ComponentDefinition {
            id: settingsPageDefinition
            source: "Settings.qml"
        },
        ComponentDefinition {
            id: appCover
            source: "AppCover.qml"
        }
    ]
    
    // Top Menu Definitions
    Menu.definition: MenuDefinition {
        // Specify the actions that should be included in the menu
        actions: [
            ActionItem {
                title: "About"
                imageSource: "asset:///images/ic_info.png"

                onTriggered: {
                    aboutDialog.open()
                }
            },
            ActionItem {
                id: settings_button
                title: "Settings"
                imageSource: "asset:///images/ic_settings.png"

                onTriggered: {
                    var newPage = settingsPageDefinition.createObject();
                    navigationPane.push(newPage);
                }
            }
        ] // actions
    } // MenuDefinition
    	
////////// PAGE ///////////////////////////////////////////////////////////////////////////////////
    	
    Page {
    	id: page
    	
///// Propertys /////
    	
        property bool clockRuns: false // is the normal clock/stopwatch running?
        property bool stopwatch: rubikTimer.stopwatchMode // is stopwatch mode selected yes/no?
        property bool inspection: rubikTimer.inspectionMode // is inspection selected yes/no?
        property int inspectionTime: rubikTimer.inspectionTime // inspection time set in settings and it's value is in seconds

        property int countdownTime: 0 // countdownTime is the inspectionTime*1000 (millisec) and is set in pre_start_controls and counted down to 0
        property bool countdownRunning: false // is the inspection countdown running?
        
        
///// Functions /////
        
        function pre_start_controls() {
            if (page.inspection) { // check that inspection is selected from options  
                
                if (page.countdownRunning == true) { // check that inspection is running or not
                    // if running stop everything and set clock to 00:00:00
                    page.countdownRunning = false
                    page.countdownTime = 0
                    startTimer.stop()
                    countdownStringGetter.stop()
                    clock.text = "00:00:00"
                }
                else {
                    // if not running start the countdown and start QTimer
                    page.countdownRunning = true
                    page.countdownTime = page.inspectionTime * 1000
                    startTimer.interval = page.countdownTime
                    
                    //update the clock one time directly with the selected inspection time
                    clock.text = rubikTimer.getNewCountdownString(page.countdownTime)

                    startTimer.start()
                    countdownStringGetter.start()
                }
            }
            else { // inspection is not selected -> start normal
                page.start_controls()
            }
        }
        
        function start_controls() {
            // stop all countdown related stuff
            page.countdownRunning = false
            countdownStringGetter.stop()
            startTimer.stop()

            // start the clock for counting up and getting your time
            rubikTimer.restartTimer() // Set QTime behind the scences back to 0 before you start
            page.clockRuns = true // Set QML start/stop indicator to true
            timeStringGetter.start() // on every timout (10ms) updates the time on the clock

            clock.textStyle.color = Color.create("#96B800") // set clock to green

            // keep the display awake, as long as the stopwatch runs
            Application.mainWindow.screenIdleMode = 1;
        }

        function reset_controls() {

            // do all important checks and saving stuff here!

            page.clockRuns = false // set QML start/stop indicator back to false
            timeStringGetter.stop() // stop getting updated times

            startTimer.stop()
            countdownStringGetter.stop()

            // allow the display to go in idle, as long as the stopwatch isn't running 
            Application.mainWindow.screenIdleMode = 1;

            clock.textStyle.color = Color.create("#000") // set clock back to black
            last_time.text = clock.text // set last time to the stopped time from clock
            clock.text = "00:00:00" // set timer text at clock back to 0

            // IF NOT STOPWATCH MODE: do all the saving and record checking stuff, IF STOPWATCH
            // we are finished, because all the saving stuff is not needed!
            if (! page.stopwatch) {
                var record = rubikTimer.checkRecord(best_time.text, last_time.text) // check for record

                // if record save the last time as new best time and show a dialog that the user got a new record
                if (record) {
                    recordToast.show()
                    // save times to save file
                    rubikTimer.saveTimes(last_time.text, last_time.text)
                } else {
                    // save times to save file
                    rubikTimer.saveTimes(best_time.text, last_time.text)
                }
            }
    }   
        
///// attached Objects of the Page /////
        
        attachedObjects: [
            // imported via qt.qtimer, exported to QML in main.cpp
            QTimer {
	            id: timeStringGetter
	            interval: 1
	            onTimeout: {
	                var newStr = rubikTimer.getNewTimeString()
	                clock.text = newStr
	            }
             },
            QTimer{
                id: countdownStringGetter
                
                /*
                 * This timer is started from pre_start_controls if inspection
                 * is activated. It get's every second/1000ms a new String 
                 * for the clock which is 1 second less than before.
                 */
                
                interval: 1000
                onTimeout: {
                    /* 
                     * countdownTime holds the time used for the countdown in ms
                     * and is really counted down until it equals 0. inspectionTime
                     * on the other side holds the selected inspection time in seconds.
                     */
                    page.countdownTime -= 1000
                    var newStr = rubikTimer.getNewCountdownString(page.countdownTime)
                    clock.text = newStr
                }
            },
            QTimer{
                id: startTimer
                /*
                 * startTimer is used to start the normal stopwatch after the countdown
                 * finished with counting down to 0. It's started in the same moment than
                 * countdownStringGetter is in the pre_start_controls and it's interval is 
                 * as long as the countdown is.
                 */
                onTimeout: {
                    countdownStringGetter.stop()
                    singleShot: true
                    onTimeout: {
                        page.start_controls()
                    }
                }
            },
            AboutDialog {
                id: aboutDialog
            },
            SystemToast {
                id: recordToast
                body: "Gratulations: That was a new record - well done!"
            }
        ]
        
        
///// START WITH THE PAGES CONTENTS /////
		
        titleBar: TitleBar {
            title: "CubeTimer"
        }

        Container {
        	id: content
            layout: DockLayout {}
            horizontalAlignment: HorizontalAlignment.Fill
            //background: Color.create("#f8f8f8")
            background: Color.create("#262626")

            Container {
                id: scramble_area
                topPadding: 30
	            leftPadding: 15
	            rightPadding: 15

                Label {
	                text: page.stopwatch ? "Stopwatch" : "Scramble:"
                    textStyle.fontStyle: FontStyle.Default
                    textStyle.fontSize: FontSize.Small
                    textStyle.fontWeight: FontWeight.Bold
                    textStyle.color: Color.create("#f8f8f8")
                }
	            
	            Label {
	                id: scrambleline
	                topMargin: 20
                    horizontalAlignment: HorizontalAlignment.Center

                    // In the stopwatch mode we do not need any times shown on UI
                    // this also indicates, that the stopwatch mode is active!
                    visible: page.stopwatch ? false : true

                    text: ""
	                multiline: true
	                textStyle.color: Color.create("#f8f8f8")
                    textStyle.fontWeight: FontWeight.W100
                    textStyle.textAlign: TextAlign.Center
                    textStyle.fontSize: FontSize.Large
                }
	        } // Container
            
	        Container {
	            id: timer_area
	            
	            layout: DockLayout{}
	
	            horizontalAlignment: HorizontalAlignment.Center
	            verticalAlignment: VerticalAlignment.Center
	            
	            ImageView {
	                id: timer_bg
	                imageSource: "asset:///images/timer_bg.png"
	            }
	                
	            Label {
	                id: clock

                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center

                    text: "00:00:00"
                    
	                textStyle.fontSize: FontSize.PointValue
                    textStyle.fontSizeValue: 36
                    textStyle.fontWeight: FontWeight.W100
                    textStyle.color: Color.create("#000")

                    onTouch: {
                       // check that the click was really a click!
                       var click = event.touchType
                       if(click == 2){
                       	   if(page.clockRuns==true){
                                page.reset_controls()		  // calls all the reset stuff in seperate function
                       	   }
                       	   else {
                       	       page.pre_start_controls()                               
                            } // else
                        } // click if
                    } // onTouch
                } // Label
	        } // Container
	        
         		Container {
		            id: times_area
		            
		            verticalAlignment: VerticalAlignment.Bottom
		            bottomPadding: 100
		            leftPadding: 20
		            
		            layout: StackLayout{}
		
					Container {
					    layout: StackLayout {
		                        orientation: LayoutOrientation.LeftToRight
		                    }
		                Label {
		                    id: best_time_label
		                  
		                    // In the stopwatch mode we do not need any times shown on UI
		                    // this also indicates, that the stopwatch mode is active!
		                    visible: page.stopwatch ? false : true

                        	text: "best: "
		                    textStyle.fontWeight: FontWeight.Bold
		                    textStyle.fontSize: FontSize.Large
		                    textStyle.color: Color.create("#f8f8f8")
		                }
		                Label {
		                    id: best_time

	                        // In the stopwatch mode we do not need any times shown on UI
	                        // this also indicates, that the stopwatch mode is active!
	                        visible: page.stopwatch ? false : true

                        	text: rubikTimer.bestTimeString
                        	textStyle.fontWeight: FontWeight.Bold
		                    textStyle.fontSize: FontSize.Large
		                    textStyle.color: Color.create("#f8f8f8")
		                }
		            }
					Container {
			            layout: StackLayout {
			                orientation: LayoutOrientation.LeftToRight
			            }
			            Label {
			                id: average_time_label

	                        // In the stopwatch mode we do not need any times shown on UI
	                        // this also indicates, that the stopwatch mode is active!
	                        visible: page.stopwatch ? false : true

                        	text: "average: "
			                textStyle.color: Color.create("#f8f8f8")
			            }
			            Label {
			                id: average_time

	                        // In the stopwatch mode we do not need any times shown on UI
	                        // this also indicates, that the stopwatch mode is active!
	                        visible: page.stopwatch ? false : true

                        	text: rubikTimer.averageTimeString
                        	textStyle.color: Color.create("#f8f8f8")
			            }
			        }
					Container {
			        	layout: StackLayout {
			                orientation: LayoutOrientation.LeftToRight
			            }
			            Label {
			                id: last_time_label
                        	text: "last: "
			                textStyle.color: Color.create("#f8f8f8")
			            }
			            Label {
			                id: last_time
	                        text: rubikTimer.lastTimeString
                        	textStyle.color: Color.create("#f8f8f8")
			            }
			        }
			    }
		} // Content Container
        
        
        ////// actions attached to the Page/ActionBar /////
        
        actions:[
            ActionItem {
                id: reset_button
                title: "Scramble"
                ActionBar.placement: ActionBarPlacement.OnBar
                imageSource: "asset:///images/ic_rotate.png"
                
                // scramble function is not needed when stopwatch mode is selected
                enabled: page.stopwatch ? false : true

                onTriggered: {
                    scrambleline.text = rubikTimer.getScrambleStr();
                }
            },
            InvokeActionItem {
                id: share
                ActionBar.placement: ActionBarPlacement.InOverflow

                query.invokeActionId: "bb.action.SHARE"
                query.mimeType: "text/plain"
                query.data: "My record at #RubikTimer for BlackBerry10 is: "+rubikTimer.bestTimeString+"! Give it a try and beat me!"
            },
            DeleteActionItem {
                id: delete_record
                title: "Reset record"
                ActionBar.placement: ActionBarPlacement.InOverflow
                
                onTriggered: {
                    rubikTimer.resetRecord()
                }
            }
        ]
    } // Page


	///// Creation of the pane finished /////
    onCreationCompleted: {
    	//set active frame cover
        Application.cover = appCover.createObject();

        //Load times from save file
        rubikTimer.loadTimes()

        // This function is called to set a first scramble command
        scrambleline.text = rubikTimer.getScrambleStr();

        // enable layout to adapt to the device rotation
        // don't forget to enable screen rotation in bar-bescriptor.xml (Application->Orientation->Auto-orient)
        OrientationSupport.supportedDisplayOrientation = SupportedDisplayOrientation.DisplayPortrait;
    }
}//NavigationPane
