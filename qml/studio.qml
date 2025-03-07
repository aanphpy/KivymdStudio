import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtCharts 2.15
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.2
import Qt.labs.folderlistmodel 2.15
import QtQml.Models 2.2
//import QtQuick.Controls 1.4 as OV
//import DotPy.Core 1.0
//import '../highlightcolor.js' as Logic
//import '..highlight.js/lib/core' as Logic
//import ArcGIS.AppFramework.Scripting 1.0
//import Qt5Compat.GraphicalEffects

ApplicationWindow {
    id:root
    width: 1000
    height: 700
    visible: true
    color: "#1F1F20"
    title: qsTr("Kivymd-Studio")

    QtObject{
        id:obj
        objectName: 'backend'

        function reparse(value){
            var dic=value
            return JSON.parse(JSON.stringify(dic))
        }
    }

    Connections{
        enabled: true
        ignoreUnknownSignals: false
        target: backend

        function onColorhighlight(value){
            return value
        }
        function onFolderOpen(value){
            return JSON.stringify(value)
        }
        
    }

    Component.onCompleted: {
        // root.showFullScreen();
        //backend.chargeTree(tree)
        root.width=parseInt(backend.getScreen().split(',')[0])
        root.height=parseInt(backend.getScreen().split(',')[1])
        loading.msgt='loading plugins...'
        loading.visible=true
        timer.interval=5000
        timer.running=true
        
        //console.log(l)
        // for(let i of JSON.parse(l)){
        //     console.log(i.name)
        //     loader.sourceComponent = lbarcomp
        //     loader.item.parent = leftcol
        //     loader.item.anchors.horizontalCenter=leftcol.horizontalCenter
        //     loader.item.icon='../plugins/python/'+i.icon
        // }
        //console.log(l)
    }

    function onLogEvent(value){
        console.log(balue)
    }

    function verify(lst,word ){
        var found=false
        for (let w of lst){
            if (w==word){
                console.log(w)
                found=true
                break
            }
            else{
                found=false
            }
        }
        //console.log(found)
        return found
    }

    function removeTab(){
        codetab.remove(codetab.currentIndex)
    }

    function colorify(text) {
        //import hljs from 'highlight.js/lib/core';
        //import python from 'highlight.js/lib/languages/python';
        try {
            Logic.hljs.registerLanguage('python', python);
            return Logic.hljs.highlight(text, { language: "python" });

        } catch (error) {
            //console.log(error)
        }
    }
    function high_l(value){
        return value.toHtmlObject
    }
    

    property color appcolor:"#1F1F20"
    property color barclaire:'#292828'
    property color barfonce:'#18191A'
    property color moyen:'#2E2F30'
    property color bordercolor:'#535353'
    property color hovercolor:'#609EAD96'
    property string emustate:'off'
    property string cde
    property string lnk
    property string imsource
    property string currentFolder
    signal emuLog(var msg)

    Shortcut {
        sequence: "Ctrl+T"
        onActivated: terminal.visible=true
    }
    Shortcut {
        sequence: "Alt+Ctrl+T"
        onActivated: terminal.visible=false
    }
    Shortcut {
        sequence: "Ctrl+N"
        onActivated: {
            //console.log('new file')
            fileop.visible=true
        }
    }
    Shortcut {
        sequence: "Ctrl+O"
        onActivated: {
            //console.log('open file')
            opfile.open()
        }
    }
    Shortcut {
        sequence: "Ctrl+K"
        onActivated:{ 
            //console.log(' folder new')
            foldn.visible=true
        }
    }
    Shortcut {
        sequence: "Alt+Ctrl+K"
        onActivated: {
            //console.log('open folder')
            opfold.open()
        }
    }
    Shortcut {
        sequence: "Ctrl+Z"
        onActivated: {
            console.log('undo')
            codetab.getTab(codetab.currentIndex).item.cd.undo()
        }
    }
    Shortcut {
        sequence: "Ctrl+Y"
        onActivated: {
            console.log('redo')
            codetab.getTab(codetab.currentIndex).item.cd.redo()
        }
    }
    Shortcut {
        sequence: "Ctrl+S"
        //enabled:parent.focus
        onActivated: {
            //console.log('saving file...')
            //console.log(codetab.getTab(codetab.currentIndex).item.lk.toString())
            cde=codetab.getTab(codetab.currentIndex).item.cd.getText(0,codetab.getTab(codetab.currentIndex).item.cd.length)
            backend.savefile(codetab.getTab(codetab.currentIndex).item.lk.toString(),backend.get_filename(codetab.getTab(codetab.currentIndex).item.lk),cde)
            //cde=''
        }
    }
    // Shortcut {
    //     sequence: "Ctrl+S"
    //     onActivated: console.log('save file')
    // }
    Shortcut {
        sequence: "Ctrl+Shift+S"
        onActivated: {
            console.log('save file as...')
        }
    }
    
    
    Rectangle{
        id:leftbar
        width:60
        height:parent.height
        color:barclaire
        anchors.left: parent.left
        property var pluglist:[xte,git,tree,searchbox]
        function leftNavigation(s){
            for (let a in pluglist){
                pluglist[a].visible=false;
                pluglist[a].enabled=false;
            }
            s.visible=true;
            s.enabled=true;
        }

        Rectangle{
            id:xhov
            height:parent.height
            width:3
            color:'white'
            anchors.left:parent.left
            visible:false
        }
        Component{
            id:lbarcomp
            Rectangle{
                height:50
                width:50
                radius:12
                color:barclaire
                anchors.horizontalCenter: parent.horizontalCenter

                Image{
                    width:25
                    height:25
                    source:icon
                    anchors.centerIn: parent
                }
                MouseArea{
                    anchors.fill: parent
                    hoverEnabled:true
                    onEntered:{
                        parent.color=hovercolor
                    }
                    onExited:{
                        parent.color=barclaire
                    }
                    onClicked:{
                        xhov.visible=true
                        xhov.parent=parent
                        //console.log(ui)
                        if (leftbox.width==0){
                            exptxt.text=name
                            lb_on.start();
                            expbox.visible=true
                            leftbar.leftNavigation(ui);
                        }
                        else if(leftbox.width>0 && ui.visible==true){
                            expbox.visible=false
                            ui.visible=false
                            lb_off.start()
                        }
                        else{
                            exptxt.text=name
                            leftbar.leftNavigation(ui);
                        }
                    }
                }
            }
        }
        ListModel{
            id:lbarmod
        }
        Component.onCompleted:{
            lbarmod.append({name:'SEARCH',icon:'../assets/icons/loupe.png',ui:searchbox})
            lbarmod.append({name:'EXPLORER',icon:'../assets/icons/fichier.png',ui:tree})
            lbarmod.append({name:'EXTENSIONS',icon:'../assets/icons/menu(1).png',ui:xte})
            lbarmod.append({name:'GITHUB',icon:'../assets/icons/github(1).png',ui:git})
            var l = obj.reparse(backend.loadPlugins())
            for(let i of JSON.parse(l)){
                var cc=Qt.createComponent('../'+i.template)
                if(cc.status==Component.ready){
                    console.log(i.template)
                    var c=cc.createObject(Rectangle,{height:200,width:100})
                    pluglist.push(c)
                    lbarmod.append({name:i.name,icon:'../plugins/python/'+i.icon,ui:c})
                }else{
                    console.log(cc.errorString())
                }
                //console.log(c)
            }
            //lbarmod.append(JSON.parse(l));
        }
        ScrollView{
            id:scleftcol
            anchors.fill:parent
            ListView{
                spacing:10
                anchors.fill:parent
                clip:true
                delegate:lbarcomp
                model:lbarmod
            }
            // Rectangle{
            //     width:50
            //     height:50
            //     radius:12
            //     //y:30
            //     color:parent.parent.color
            //     anchors.horizontalCenter: parent.horizontalCenter

            //     Image{
            //         width:25
            //         height:25
            //         source:'../assets/icons/loupe.png'
            //         anchors.centerIn: parent
            //     }

            //     MouseArea{
            //         anchors.fill: parent
            //         hoverEnabled:true
            //         onEntered:{
            //             parent.color=hovercolor
            //         }
            //         onExited:{
            //             parent.color=barclaire
            //         }
            //         onClicked:{
            //             xhov.parent=parent;
            //             xhov.visible=true;
            //             if (leftbox.width==0){
            //                 expbox.visible=true
            //                 exptxt.text='SEARCH'
            //                 xte.visible=false
            //                 git.visible=false
            //                 tree.visible=false
            //                 searchbox.visible=true
            //                 tree.visible=false
            //                 lb_on.start()
            //             }
            //             else if(leftbox.width>0 && searchbox.visible==true){
            //                 expbox.visible=false
            //                 xte.visible=false
            //                 git.visible=false
            //                 tree.visible=false
            //                 searchbox.visible=false
            //                 tree.visible=false
            //                 lb_off.start()
            //             }
            //             else{
            //                 exptxt.text='SEARCH'
            //                 xte.visible=false
            //                 git.visible=false
            //                 tree.visible=false
            //                 searchbox.visible=true
            //                 tree.visible=false
            //             }
            //         }
            //     }
            // }
            // Rectangle{
            //     width:50
            //     height:50
            //     radius:12
            //     y:90
            //     color:parent.parent.color
            //     anchors.horizontalCenter: parent.horizontalCenter

            //     Image{
            //         width:25
            //         height:25
            //         source:'../assets/icons/fichier.png'
            //         anchors.centerIn: parent
            //     }

            //     MouseArea{
            //         anchors.fill: parent
            //         hoverEnabled:true
            //         onEntered:{
            //             parent.color=hovercolor
            //         }
            //         onExited:{
            //             parent.color=barclaire
            //         }
            //         onClicked:{
            //             xhov.parent=parent;
            //             xhov.visible=true;
            //             if (leftbox.width==0){
            //                 expbox.visible=true
            //                 exptxt.text='EXPLORER'
            //                 xte.visible=false
            //                 git.visible=false
            //                 tree.visible=false
            //                 searchbox.visible=false
            //                 tree.visible=true
            //                 lb_on.start()
            //             }
            //             else if(leftbox.width>0 && tree.visible==true){
            //                 expbox.visible=false
            //                 xte.visible=false
            //                 git.visible=false
            //                 tree.visible=false
            //                 searchbox.visible=false
            //                 tree.visible=false
            //                 lb_off.start()
            //             }
            //             else{
            //                 exptxt.text='EXPLORER'
            //                 xte.visible=false
            //                 git.visible=false
            //                 tree.visible=false
            //                 searchbox.visible=false
            //                 tree.visible=true
            //             }
            //         }
            //     }
                
            // }
            // Rectangle{
            //     width:50
            //     height:50
            //     radius:12
            //     y:150
            //     color:parent.parent.color
            //     anchors.horizontalCenter: parent.horizontalCenter

            //     Image{
            //         width:25
            //         height:25
            //         source:'../assets/icons/menu(1).png'
            //         anchors.centerIn: parent
            //     }

            //     MouseArea{
            //         anchors.fill: parent
            //         hoverEnabled:true
            //         onEntered:{
            //             parent.color=hovercolor
            //         }
            //         onExited:{
            //             parent.color=barclaire
            //         }
            //         onClicked:{
            //             xhov.parent=parent;
            //             xhov.visible=true;
            //             if (leftbox.width==0){
            //                 expbox.visible=true
            //                 exptxt.text='EXTENTIONS'
            //                 xte.visible=true
            //                 git.visible=false
            //                 tree.visible=false
            //                 searchbox.visible=false
            //                 tree.visible=false
            //                 lb_on.start()
            //             }
            //             else if(leftbox.width>0 && xte.visible==true){
            //                 expbox.visible=false
            //                 xte.visible=false
            //                 git.visible=false
            //                 tree.visible=false
            //                 searchbox.visible=false
            //                 tree.visible=false
            //                 lb_off.start()
            //             }
            //             else{
            //                 exptxt.text='EXTENTIONS'
            //                 xte.visible=true
            //                 git.visible=false
            //                 tree.visible=false
            //                 searchbox.visible=false
            //                 tree.visible=false
            //             }
            //         }
            //     }
                
            // }
            // Rectangle{
            //     width:50
            //     height:50
            //     radius:12
            //     y:210
            //     color:parent.parent.color
            //     anchors.horizontalCenter: parent.horizontalCenter

            //     Image{
            //         width:25
            //         height:25
            //         source:'../assets/icons/github(1).png'
            //         anchors.centerIn: parent
            //     }

            //     MouseArea{
            //         anchors.fill: parent
            //         hoverEnabled:true
            //         onEntered:{
            //             parent.color=hovercolor
            //         }
            //         onExited:{
            //             parent.color=barclaire
            //         }
            //         onClicked:{
            //             xhov.parent=parent;
            //             xhov.visible=true;
            //             if (leftbox.width==0){
            //                 expbox.visible=true
            //                 exptxt.text='GITHUB'
            //                 xte.visible=false
            //                 git.visible=true
            //                 tree.visible=false
            //                 searchbox.visible=false
            //                 tree.visible=false
            //                 lb_on.start()
            //             }
            //             else if(leftbox.width>0 && git.visible==true){
            //                 expbox.visible=false
            //                 xte.visible=false
            //                 git.visible=false
            //                 tree.visible=false
            //                 searchbox.visible=false
            //                 tree.visible=false
            //                 lb_off.start()
            //             }
            //             else{
            //                 exptxt.text='GITHUB'
            //                 xte.visible=false
            //                 git.visible=true
            //                 tree.visible=false
            //                 searchbox.visible=false
            //                 tree.visible=false
            //             }
            //         }
            //     }
            // }
        }
        Rectangle{
            width:50
            height:50
            radius:12
            y:parent.height-110
            color:parent.color
            anchors.horizontalCenter: parent.horizontalCenter

            Image{
                width:35
                height:35
                source:'../assets/icons/coffee4.png'
                anchors.centerIn: parent
            }

            MouseArea{
                anchors.fill: parent
                hoverEnabled:true
                onEntered:{
                    parent.color=hovercolor
                }
                onExited:{
                    parent.color=barclaire
                }
                onClicked:{
                    
                }
            }
        }
        Rectangle{
            width:50
            height:50
            radius:12
            y:parent.height-60
            color:parent.color
            anchors.horizontalCenter: parent.horizontalCenter

            Image{
                width:25
                height:25
                source:'../assets/icons/param.png'
                anchors.centerIn: parent
            }

            MouseArea{
                anchors.fill: parent
                hoverEnabled:true
                onEntered:{
                    parent.color=hovercolor
                }
                onExited:{
                    parent.color=barclaire
                }
                onClicked:{
                    paramMenu.open()
                }
            }
            Menu{
                id:paramMenu
                height: 250
                width: 200
                x:parent.width
                y:parent.parent.height-height-50
                background: Rectangle{
                    color:barclaire
                    anchors.fill:parent
                    border.color:bordercolor
                    border.width: 1
                }
                MenuItem{
                    Text{
                        text:'Highlight Theme'
                        color:'#3B7EAC'
                        font.pixelSize:15
                        x:15
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                MenuItem{
                    Text{
                        text:'Highlight Theme'
                        color:'#3B7EAC'
                        font.pixelSize:15
                        x:15
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                MenuItem{
                    Text{
                        text:'Highlight Theme'
                        color:'#3B7EAC'
                        font.pixelSize:15
                        x:15
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                MenuItem{
                    Text{
                        text:'Highlight Theme'
                        color:'#3B7EAC'
                        font.pixelSize:15
                        x:15
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                MenuItem{
                    Text{
                        text:'Highlight Theme'
                        color:'#3B7EAC'
                        font.pixelSize:15
                        x:15
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }
    NumberAnimation{
        id:lb_on
        from: 0
        to: (root.width/5)
        duration: 200
        property: 'width'
        target:leftbox
    }
    NumberAnimation{
        id:lb_off
        from: (root.width/5)
        to: 0
        duration: 200
        property: 'width'
        target:leftbox
    }
    Rectangle{
        id:leftbox
        x:leftbar.width
        width:(root.width/5)
        height:parent.height
        color:moyen

        Rectangle{
            id:expbox
            width:parent.width
            height:35
            color:moyen
            border.color:bordercolor
            border.width:1
            
            UIText{
                id:exptxt
                y:10
                text:qsTr('Explorer')
                font.pixelSize:12
                color:'white'
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Rectangle{
                id:exphead
                width:20
                height:25
                y:5
                color:parent.color
                radius:10
                anchors.right:parent.right
                anchors.margins: 5
                //anchors.verticalCenter: parent.verticalCenter
                
                Image{
                    width:20
                    height:20
                    source:'../assets/icons/men.png'
                    anchors.centerIn: parent
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled:true
                    onEntered:{
                        exphead.color=hovercolor
                    }
                    onExited:{
                        exphead.color=moyen
                    }
                    onClicked:{
                        opt.visible=true
                    }
                }
            }
        }

        Rectangle{
            id:searchbox
            y:expbox.height+1
            width:parent.width
            height:parent.height-expbox.height-2
            color:parent.color
            visible:false

            TextField{
                y:20
                width:parent.width-20
                height:30
                anchors.horizontalCenter: parent.horizontalCenter
                color:'#AEB5BD'
                font.pixelSize:13
                background: Rectangle{
                    anchors.fill: parent
                    radius:10
                    color:barfonce
                    border.width:1
                    border.color:'#045685'
                }
                placeholderText: 'Search...'
                placeholderTextColor: moyen
                leftPadding: 10
                bottomPadding:3
                
            }
            Image{
                width:150
                height:200
                source:'../assets/icons/magnify.png'
                anchors.centerIn: parent
            }
        }

        Rectangle{
            id:tree
            y:expbox.height
            color:parent.color
            width:parent.width
            height:parent.height-expbox.height
            objectName:'folder'

            FileManager{
                id:fm
                anchors.fill: parent
                bscolor:parent.color
                onFileSelected:{
                    //console.log(file,'11111111')
                    var tx=backend.openfile(file)
                    cde=tx
                    lnk=file.toString()
                    var tl=backend.get_filename(file)
                    if(codetab.contains(tl)==true){
                        let idx=codetab.indexOf(tl)
                        if(codetab.currentIndex>idx){
                            codetab.currentIndex-=codetab.currentIndex-idx
                        }else if(codetab.currentIndex<idx){
                            codetab.currentIndex+=idx-codetab.currentIndex
                        }else{
                            //nothings!
                        }
                    }else{
                        if (tl.substr(-4,4)=='.png' ||tl.substr(-4,4)=='.PNG' ||tl.substr(-4,4)=='.jpg' ||tl.substr(-4,4)=='.JPG' ||tl.substr(-5,5)=='.jpeg' ||tl.substr(-5,5)=='.JPEG' ||tl.substr(-4,4)=='.svg' ||tl.substr(-5,5)=='.webp' ||tl.substr(-5,5)=='.WEBP'){
                            imsource=file
                            codetab.insertTab(codetab.currentIndex+1,tl,imcomp)
                        }else{
                            codetab.insertTab(codetab.currentIndex+1,tl,cb)
                        }
                    }
                    //codetab.getTab(codetab.currentIndex+1).visible=true
                }
                onFolderSwiped:{
                    root.currentFolder=path;
                    console.log(root.currentFolder)
                }
            }
            Component{
                id:imcomp
                Rectangle{
                    id:imrect
                    color:root.color
                    width:codetab.width-400
                    height:codetab.height-200
                    anchors.centerIn: parent
                    Image{
                        id:imv
                        width:parent.width-200
                        height:parent.height-200
                        fillMode:Image.PreserveAspectFit
                        //anchors.fill: imrect
                        anchors.centerIn: parent
                        source:''
                    }
                    Component.onCompleted:{
                        imv.source=imsource
                    }
                }
            }

            // CustomTree{
            //     id:ftree
            //     anchors.fill: parent
            // }

            // Component{
            //     id:lstdlg
            //     Rectangle{
            //         id:lrec
            //         width:tree.width
            //         height:30
            //         color:'#34373A'
            //         radius:8
            //         border.width:1
            //         border.color:bordercolor

            //         Image{
            //             id:fimg
            //             width:15
            //             height:15
            //             anchors.left:parent.left
            //             anchors.leftMargin:10
            //             anchors.verticalCenter: parent.verticalCenter
            //             source:'../assets/icons/folderadd.png'
            //         }
            //         Text{
            //             id:ftx
            //             text:filename
            //             font.pixelSize:14
            //             color:'white'
            //             x:5
            //             anchors.verticalCenter: parent.verticalCenter
            //         }
            //         MouseArea{
            //             anchors.fill: parent
            //             hoverEnabled:true
            //             onEntered:{
            //                 parent.color=hovercolor
            //                 //parent.visible=false
            //             }
            //             onExited:{
            //                 parent.color='#34373A'
            //             }
            //             onClicked:{
            //                 var xx=lll.currentItem.x
            //                 var yy=lll.currentItem.y
            //                 var colps=false
            //                 if(colps==false){

            //                     for(var i=lll.currentIndex+1;i<lll.count;i++){
            //                         lll.incrementCurrentIndex()
            //                         if(lll.currentItem.x>xx){
            //                             lll.currentItem.visible=false
            //                         }else{
            //                             break
            //                         }
            //                     }
            //                     colps=true
            //                 }else{
            //                     for(var i=lll.currentIndex+1;i<lll.count;i++){
            //                         lll.incrementCurrentIndex()
            //                         if(lll.currentItem.x>xx){
            //                             lll.currentItem.visible=true
            //                         }else{
            //                             break
            //                         }
            //                     }
            //                 }
            //             }
            //         }
            //         Component.onCompleted:{
            //             //f=ftx.text.match(/  |/)
            //             var o=ftx.text.toString().split(/├─|└─|[  ]|│ /).length-1
            //             var l=o*2
            //             ftx.text=ftx.text.substr(l-1,ftx.text.length-l)
            //             if(ftx.text.length>13){
            //                 ftx.text=ftx.text.substr(0,10)+'...'
            //             }
            //             ftx.x=40
            //             lrec.x=(o)*10
            //             lrec.width-=lrec.x
            //         }
            //     }
            // }
            
            // ListModel{
            //     id:tmod
            //     // ListElement{
            //     //     filename:'/root'
            //     // }
                
            // }
            

            // ScrollView{
            //     anchors.fill: parent
            //     ListView{
            //         id:lll
            //         model:tmod
            //         delegate:lstdlg
            //         //draggingVertically: true
            //     }
            // }
            
        }
        Rectangle{
            id:xte
            y:expbox.height+1
            width:parent.width
            height:parent.height-expbox.height-2
            color:parent.color
            visible:false
            Text{
                text:'Extentions'
                anchors.centerIn: parent
                color:'white'
            }
        }
        Rectangle{
            id:git
            y:expbox.height+1
            width:parent.width
            height:parent.height-expbox.height-2
            color:parent.color
            visible:false
            Image{
                y:150
                width:150
                height:200
                source:'../assets/icons/git.png'
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text{
                text:'Github'
                anchors.centerIn: parent
                color:'white'
            }
        }

        Rectangle{
            id:opt
            x:15
            y:45
            height:45
            color:barfonce
            border.width:1
            border.color:bordercolor
            width:parent.width-15
            Material.elevation:6
            visible:false

            Rectangle{
                width:18
                height:18
                radius:20
                color:barclaire
                anchors.right:parent.right
                anchors.margins:5
                anchors.verticalCenter: parent.verticalCenter

                Text{
                    text:qsTr('×')
                    color:'white'
                    font.pixelSize:12
                    anchors.centerIn: parent
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled:true
                    onEntered:{
                        parent.color=hovercolor
                    }
                    onExited:{
                        parent.color=barfonce
                    }
                    onClicked:{
                        opt.visible=false
                    }
                }
                
            }

            Rectangle{
                width:20
                height:20
                x:10
                radius:8
                color:parent.color
                anchors.verticalCenter: parent.verticalCenter

                Image{
                    width:17
                    height:17
                    source:'../assets/icons/addfile.png'
                    anchors.centerIn: parent
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled:true
                    onEntered:{
                        parent.color=hovercolor
                    }
                    onExited:{
                        parent.color=barfonce
                    }
                    onClicked:{
                        fileop.visible=true
                    }
                }
            }
            Rectangle{
                width:20
                height:20
                x:40
                radius:8
                color:parent.color
                anchors.verticalCenter: parent.verticalCenter

                Image{
                    width:17
                    height:17
                    source:'../assets/icons/folderadd.png'
                    anchors.centerIn: parent
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled:true
                    onEntered:{
                        parent.color=hovercolor
                    }
                    onExited:{
                        parent.color=barfonce
                    }
                    onClicked:{
                        foldn.visible=true
                    }
                }
                
            }

            Rectangle{
                width:20
                height:20
                x:70
                radius:8
                color:parent.color
                anchors.verticalCenter: parent.verticalCenter

                Image{
                    width:17
                    height:17
                    source:'../assets/icons/ref.png'
                    anchors.centerIn: parent
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled:true
                    onEntered:{
                        parent.color=hovercolor
                    }
                    onExited:{
                        parent.color=barfonce
                    }
                    onClicked:{
                        
                    }
                }
                
            }
        }
        
    }
    Rectangle{
        id:top_bar
        x:leftbar.width+leftbox.width
        height:40
        color:barfonce
        width:parent.width-leftbar.width-leftbox.width
        anchors.top:parent.top

        Rectangle{
            width:(parent.width*2/3)-10
            height:parent.height-10
            anchors.left:parent.left
            anchors.margins: 5
            color:parent.color
            anchors.verticalCenter: parent.verticalCenter

            Row{
                spacing: 10
                topPadding:12
                height: parent.height
                Rectangle{
                    //x:10
                    height:parent.height
                    width:70
                    color:top_bar.color
                    anchors.verticalCenter: parent.verticalCenter
                    Text{
                        text:'Files'
                        color:'#3B7EAC'
                        font.pixelSize:15
                        anchors.centerIn: parent
                    }
                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled:true
                        onClicked:{
                            filesmen.open()
                        }
                        onEntered:{
                            parent.color=hovercolor
                        }
                        onExited:{
                            parent.color=top_bar.color
                        }
                    }
                }
                
                Rectangle{
                    //x:90
                    height:parent.height
                    color:top_bar.color
                    anchors.verticalCenter: parent.verticalCenter
                    width:70
                    Text{
                        text:'Edition'
                        color:'#3B7EAC'
                        font.pixelSize:15
                        anchors.centerIn: parent
                    }
                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled:true
                        onClicked:{
                            editmen.open()
                        }
                        onEntered:{
                            parent.color=hovercolor
                        }
                        onExited:{
                            parent.color=top_bar.color
                        }
                    }
                }

                Rectangle{
                    //x:170
                    height:parent.height
                    color:top_bar.color
                    anchors.verticalCenter: parent.verticalCenter
                    width:70
                    Text{
                        text:'Terminal'
                        color:'#3B7EAC'
                        font.pixelSize:15
                        anchors.centerIn: parent
                    }
                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled:true
                        onClicked:{
                            terminalmen.open()
                        }
                        onEntered:{
                            parent.color=hovercolor
                        }
                        onExited:{
                            parent.color=top_bar.color
                        }
                    }
                }
                Rectangle{
                    //x:250
                    id:plug
                    height:parent.height
                    color:top_bar.color
                    anchors.verticalCenter: parent.verticalCenter
                    width:70
                    Text{
                        text:'Plugins'
                        color:'#3B7EAC'
                        font.pixelSize:15
                        anchors.centerIn: parent
                    }
                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled:true
                        onClicked:{
                            pluginsmen.open()
                        }
                        onEntered:{
                            parent.color=hovercolor
                        }
                        onExited:{
                            parent.color=top_bar.color
                        }
                    }
                }
                Rectangle{
                    //x:250
                    height:parent.height
                    color:top_bar.color
                    anchors.verticalCenter: parent.verticalCenter
                    width:70
                    Text{
                        text:'Help'
                        color:'#3B7EAC'
                        font.pixelSize:15
                        anchors.centerIn: parent
                    }
                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled:true
                        onClicked:{
                            helpmen.open()
                        }
                        onEntered:{
                            parent.color=hovercolor
                        }
                        onExited:{
                            parent.color=top_bar.color
                        }
                    }
                }
            }
        }

        Menu{
            id:pluginsmen
            x:plug.x+5
            y:top_bar.height
            // title: string
            // delegate: Component
            // contentModel: model
            width:200
            //height:250
            background: Rectangle{
                color:barclaire
                border.width:1
                anchors.fill: parent
                border.color:bordercolor
            }
            MenuItem{
                Text{
                    text:'Install Plugin'
                    color:'#3B7EAC'
                    font.pixelSize:15
                    x:15
                    anchors.verticalCenter: parent.verticalCenter
                }
                onClicked:{
                    //fileop.visible=true
                    //console.log('install plugin')
                    plugdialog.open()
                }
            }
            MenuItem{
                Text{
                    text:'Plugins List'
                    color:'#3B7EAC'
                    font.pixelSize:15
                    x:15
                    anchors.verticalCenter: parent.verticalCenter
                }
                onClicked:{
                    //fileop.visible=true
                    //console.log('list plugins')
                }
            }
            MenuItem{
                Text{
                    text:'Uninstall Plugin'
                    color:'#3B7EAC'
                    font.pixelSize:15
                    x:15
                    anchors.verticalCenter: parent.verticalCenter
                }
                onClicked:{
                    //fileop.visible=true
                    //console.log('install plugins')
                }
            }
        }
        
        Menu{
            id:helpmen
            x:260
            y:top_bar.height
            width:150
            height:100
            background: Rectangle{
                color:barclaire
                border.width:1
                anchors.fill: parent
                border.color:bordercolor
            }
            MenuItem{
                Text{
                    text:'Help'
                    color:'#3B7EAC'
                    font.pixelSize:15
                    x:15
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            MenuItem{
                Text{
                    text:'About'
                    color:'#3B7EAC'
                    font.pixelSize:15
                    x:15
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
        Menu{
            id:terminalmen
            x:180
            y:top_bar.height
            width:250
            height:100
            background: Rectangle{
                color:barclaire
                border.width:1
                anchors.fill: parent
                border.color:bordercolor
            }
            MenuItem{
                Text{
                    text:'New Terminal  Ctrl + t'
                    color:'#3B7EAC'
                    font.pixelSize:15
                    x:15
                    anchors.verticalCenter: parent.verticalCenter
                }
                onClicked:{
                    terminal.visible=true
                }
            }
            MenuItem{
                Text{
                    text:'Close Terminal  Alt+ Ctrl +t'
                    color:'#3B7EAC'
                    font.pixelSize:15
                    x:15
                    anchors.verticalCenter: parent.verticalCenter
                }
                onClicked:{
                    terminal.visible=false
                }
            }
        }
        Menu{
            id:editmen
            x:100
            y:top_bar.height
            width:200
            height:200
            background: Rectangle{
                color:barclaire
                border.width:1
                anchors.fill: parent
                border.color:bordercolor
            }
            MenuItem{
                Text{
                    text:'Copy   Ctrl + C'
                    color:'#3B7EAC'
                    font.pixelSize:15
                    x:15
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            MenuItem{
                Text{
                    text:'Cut    Ctrl + X'
                    color:'#3B7EAC'
                    font.pixelSize:15
                    x:15
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            MenuItem{
                Text{
                    text:'Paste   Ctrl + V'
                    color:'#3B7EAC'
                    font.pixelSize:15
                    x:15
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            MenuItem{
                Text{
                    text:'Redo   Ctrl + R'
                    color:'#3B7EAC'
                    font.pixelSize:15
                    x:15
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            MenuItem{
                Text{
                    text:'Undo   Ctrl + Z'
                    color:'#3B7EAC'
                    font.pixelSize:15
                    x:15
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
        Menu{
            id:filesmen
            x:10
            y:top_bar.height
            // title: string
            // delegate: Component
            // contentModel: model
            width:200
            height:250
            background: Rectangle{
                color:barclaire
                border.width:1
                anchors.fill: parent
                border.color:bordercolor
            }
            MenuItem{
                Text{
                    text:'New file'
                    color:'#3B7EAC'
                    font.pixelSize:15
                    x:15
                    anchors.verticalCenter: parent.verticalCenter
                }
                onClicked:{
                    fileop.visible=true
                }
            }
            MenuItem{
                Text{
                    text:'Open file'
                    color:'#3B7EAC'
                    font.pixelSize:15
                    x:15
                    anchors.verticalCenter: parent.verticalCenter
                }
                onClicked:{
                    opfile.open()
                }
            }
            MenuItem{
                Text{
                    text:'New folder'
                    color:'#3B7EAC'
                    font.pixelSize:15
                    x:15
                    anchors.verticalCenter: parent.verticalCenter
                }
                onClicked: {
                    foldn.visible=true
                }
            }
            MenuItem{
                Text{
                    text:'Open folder'
                    color:'#3B7EAC'
                    font.pixelSize:15
                    x:15
                    anchors.verticalCenter: parent.verticalCenter
                }
                onClicked:{
                    opfold.open()
                }
            }
            MenuItem{
                Text{
                    text:'New Project'
                    color:'#3B7EAC'
                    font.pixelSize:15
                    x:15
                    anchors.verticalCenter: parent.verticalCenter
                }
                onClicked: {
                    newproj.open()
                }
            }
            MenuItem{
                Text{
                    text:'Open Project'
                    color:'#3B7EAC'
                    font.pixelSize:15
                    x:15
                    anchors.verticalCenter: parent.verticalCenter
                }
                onClicked: {
                    //newproj.open()
                }
            }
            MenuItem{
                Text{
                    text:'Save file'
                    color:'#3B7EAC'
                    font.pixelSize:15
                    x:15
                    anchors.verticalCenter: parent.verticalCenter
                }
                onClicked: {
                    cde=codetab.getTab(codetab.currentIndex).item.cd.getText(0,codetab.getTab(codetab.currentIndex).item.cd.length)
                    backend.savefile(codetab.getTab(codetab.currentIndex).item.lk.toString(),backend.get_filename(codetab.getTab(codetab.currentIndex).item.lk),cde)
                }
            }
            MenuItem{
                Text{
                    text:'Save as'
                    color:'#3B7EAC'
                    font.pixelSize:15
                    x:15
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            
        }
        

        Rectangle{
            anchors.right:parent.right
            anchors.margins: 15
            height:parent.height-10
            width:parent.width/3
            y:5
            color:parent.color
            Rectangle{
                id:runer
                width:22
                height:parent.height
                radius:6
                //border.color:bordercolor
                //border.width:1
                color:parent.color
                Image{
                    id:runimg
                    width:15
                    height:15
                    source:'../assets/icons/run.png'
                    anchors.centerIn: parent
                }
            }
            Rectangle{
                //x:90
                color:parent.color
                height:parent.height
                width:emimg.width+4
                radius:6
                //border.color:bordercolor
                anchors.right:parent.right
                anchors.margins: 50+list.width
                //border.width:1

                // Text{
                //     text:'Emulator'
                //     color:'#5E6266'
                //     font.pixelSize:14
                //     x:5
                //     anchors.verticalCenter: parent.verticalCenter
                // }
                Image{
                    id:emimg
                    width:22
                    height:22
                    source:'../assets/icons/emu.png'
                    anchors.centerIn: parent
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled:true
                    onEntered:{
                        //parent.color=hovercolor
                    }
                    onExited:{
                        parent.color=top_bar.color
                    }
                    onClicked:{
                        if(emmubox.visible==true){
                            emu_off.start()
                            emmubox.visible=false
                            emustate='off'
                            //backend.emulator()
                        }else{
                            //backend.emulator()
                            emu_on.start()
                            emmubox.visible=true
                            emustate='on'
                            
                        }
                    }
                }
            }

            Rectangle{
                id:list
                width:30
                height:parent.height-2
                anchors.right:parent.right
                radius:4
                color:parent.color
                border.color:bordercolor
                border.width:1
                anchors.margins: 30
                anchors.verticalCenter: parent.verticalCenter
                Image{
                    source:'../assets/icons/list.png'
                    width:parent.width-5
                    height:parent.height-5
                    anchors.centerIn: parent
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled:true
                    onClicked:{
                        avd.open()
                    }
                    onEntered:{
                        parent.color=hovercolor
                    }
                    onExited:{
                        parent.color=top_bar.color
                    }
                }
                
            }
            Menu{
                id:avd
                y:top_bar.height
                width:200
                height:250
                x:list.x
                //anchors.right:parent.right
                //anchors.margins: 15
                
                background:Rectangle{
                    anchors.fill: parent
                    color:barclaire
                }
                MenuItem{
                    Text{
                        text:'Android 11'
                        color:'#3B7EAC'
                        font.pixelSize:15
                        x:15
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                MenuItem{
                    Text{
                        text:'Android 10  '
                        color:'#3B7EAC'
                        font.pixelSize:15
                        x:15
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                MenuItem{
                    Text{
                        text:'Android 9'
                        color:'#3B7EAC'
                        font.pixelSize:15
                        x:15
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                MenuItem{
                    Text{
                        text:'Iphone 12'
                        color:'#3B7EAC'
                        font.pixelSize:15
                        x:15
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                MenuItem{
                    Text{
                        text:'Iphone 11'
                        color:'#3B7EAC'
                        font.pixelSize:15
                        x:15
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                MenuItem{
                    Text{
                        text:'Iphone 7'
                        color:'#3B7EAC'
                        font.pixelSize:15
                        x:15
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }
    Rectangle{
        id:body
        y:top_bar.height
        color:appcolor
        x:leftbar.width+leftbox.width
        height:parent.height-top_bar.height
        width:root.width-x//leftbar.width-leftbox.width

        
        TabView{
            id:codetab
            anchors.fill: parent
            style: TabViewStyle {
                frameOverlap: 1
                tab: Rectangle {
                    color: styleData.selected ? barfonce :barclaire
                    border.color:  barclaire
                    implicitWidth: Math.max(text.width + 30, 140)
                    implicitHeight: 20
                    width:120
                    height:40
                    radius: 2
                    

                    Image{
                        id:fileimage
                        height:20
                        width:20
                        x:8
                        y:10
                        source: '' 
                    }

                    Component.onCompleted:{
                        var ext=styleData.title.substr(-3,3)
                        //console.log(ext)
                        if (ext=='.kv'){
                            fileimage.source='../assets/images/kivy.png'
                        }
                        else if(ext=='.py'){
                            fileimage.source='../assets/images/py.png'
                        }else if(ext=='ome'){
                            fileimage.source='../assets/images/coding.png'
                        }else if(ext=='cpp'){
                            fileimage.source='../assets/images/cpp.png'
                        }else if(ext=='.js'){
                            fileimage.source='../assets/images/js.png'
                        }else if(ext=='.md'){
                            fileimage.source='../assets/images/md.png'
                        }
                    }

                    Text {
                        id: text
                        anchors.centerIn: parent
                        text: styleData.title
                        font.pixelSize:12
                        color: styleData.selected ? "white" : '#A4A5A7'
                    }

                    Rectangle{
                        anchors.right:parent.right
                        anchors.margins: 8
                        y:10
                        width:15
                        height:15
                        radius:3
                        color:barfonce

                        Text{
                            text:qsTr('×')
                            font.pixelSize:13
                            color:'white'
                            anchors.centerIn: parent
                        }
                        MouseArea{
                            anchors.fill: parent
                            hoverEnabled:true
                            onEntered:{
                                parent.color=hovercolor
                            }
                            onExited:{
                                parent.color=barfonce
                            }
                            onClicked:{
                                // parent.styleData.selected
                                codetab.rmTab(styleData.index)
                            }
                        }
                    }
                    Rectangle{
                        width:1
                        color:'#0A0A0A'
                        height:parent.height
                        anchors.right:parent.right
                    }
                }
                frame: Rectangle { color: root.color }
                tabsMovable: true
            }
            
            Tab{
                title: 'Wellcome'
                active: true
                //asynchronous: bool
                Rectangle{
                    color:body.color
                    anchors.fill: parent

                    Text{
                        id:weltext
                        text:qsTr('Welcome To Kivymd Studio')
                        //font.bold:true
                        color:'#C6D6DF'
                        font.pixelSize:parent.height/12
                        y:parent.height/6
                        anchors.horizontalCenter: parent.horizontalCenter

                        
                    }
                    Rectangle{
                        y:weltext.height+weltext.y+10
                        height:(parent.height/4)+15
                        width:parent.width//-120
                        color:parent.color

                        Row{
                            anchors.fill:parent
                            anchors.margins:15
                            spacing:30
                            Rectangle{
                                height:parent.height-10
                                width:(parent.width/5)-30
                                color:parent.parent.color
                                DeviceBox{
                                    id:android
                                    src:'../assets/images/android.png'
                                    name:'Android'
                                    text_color:weltext.color
                                    rect_height:parent.height
                                    rect_width:parent.width
                                    // anchors.left:parent.left
                                    // anchors.margins: 80
                                    //y:linux.y
                                    back:parent.color
                                }
                            }
                            Rectangle{
                                height:parent.height-10
                                width:(parent.width/5)-30
                                color:parent.parent.color
                                DeviceBox{
                                    id:ios
                                    src:'../assets/images/apple.png'
                                    name:'IOs X'
                                    text_color:weltext.color
                                    rect_height:parent.height
                                    rect_width:parent.width
                                    // anchors.left:parent.left
                                    // anchors.margins: android.rect_width+120
                                    back:parent.color
                                    //y:linux.y
                                }
                            }
                            Rectangle{
                                height:parent.height-10
                                width:(parent.width/5)-30
                                color:parent.parent.color
                                DeviceBox{
                                    id:win10
                                    src:'../assets/images/win10.png'
                                    name:'Windows'
                                    text_color:weltext.color
                                    rect_height:parent.height
                                    rect_width:parent.width
                                    //anchors.horizontalCenter: parent.horizontalCenter
                                    back:parent.color
                                    //y:linux.y
                                }
                            }
                            Rectangle{
                                height:parent.height-10
                                width:(parent.width/5)-30
                                color:parent.parent.color
                                DeviceBox{
                                    id:macos
                                    src:'../assets/images/mac.png'
                                    name:'Mac Os'
                                    text_color:weltext.color
                                    rect_height:parent.height
                                    rect_width:parent.width
                                    // anchors.right:parent.right
                                    // anchors.margins: linux.rect_width+120
                                    back:parent.color
                                    //y:linux.y
                                }
                            }
                            Rectangle{
                                height:parent.height-10
                                width:(parent.width/5)-30
                                color:parent.parent.color
                                DeviceBox{
                                    id:linux
                                    src:'../assets/images/linux.png'
                                    name:'Linux'
                                    text_color:weltext.color
                                    rect_height:parent.height
                                    rect_width:parent.width
                                    // anchors.right:parent.right
                                    // anchors.margins: 80
                                    back:parent.color
                                    //y:5//weltext.height+weltext.y+10
                                }
                            }
                        }
                    }
                    
                    Rectangle{
                        y:weltext.height+60+linux.height
                        width:parent.width
                        color:parent.color
                        height:(parent.height/3)+50
                        anchors.bottom:parent.bottom
                        anchors.margins: 20
                        

                        Rectangle{
                            id:recents
                            //x:parent.width/5
                            // y:weltext.height+90+170
                            border.width:1
                            border.color:bordercolor
                            width:(parent.width/3)+30
                            height:parent.height-10
                            color:barfonce
                            anchors.left:parent.left
                            anchors.margins: 90
                            anchors.verticalCenter: parent.verticalCenter
                            UIText{
                                id:uit
                                y:7
                                text:qsTr('Recents')
                                font.pixelSize:16
                                color:bordercolor
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            Rectangle{
                                y:uit.height+10
                                height:parent.height-uit.height-11
                                width:parent.width-2
                                anchors.horizontalCenter: parent.horizontalCenter
                                color:parent.color
                                Component.onCompleted:{
                                    recmod.append(JSON.parse(backend.recents()))
                                }

                                Component{
                                    id:lcomp
                                    Rectangle{
                                        width:rlist.width-4
                                        height:30
                                        color:'transparent'
                                        //anchors.horizontalCenter: parent.horizontalCenter
                                        
                                        Text{
                                            id:rtx
                                            x:5
                                            text:fname
                                            font.pixelSize:14
                                            color:'#4FA3E7'
                                            anchors.verticalCenter: parent.verticalCenter
                                        }

                                        Rectangle{
                                            width:50
                                            height:parent.height-10
                                            radius:6
                                            anchors.right:parent.right
                                            anchors.verticalCenter: parent.verticalCenter
                                            anchors.margins: 5
                                            color:'#5699D8'
                                            
                                            Text{
                                                text:'open'
                                                anchors.centerIn: parent
                                                font.pixelSize:14
                                                color:'white'
                                            }
                                            MouseArea{
                                                anchors.fill:parent
                                                hoverEnabled:true
                                                onClicked:{
                                                    var tx=backend.openfile('file://'+rtx.text)
                                                    cde=tx
                                                    lnk='file://'+rtx.text.toString()
                                                    var tl=backend.get_filename('file://'+rtx.text)
                                                    if (tl.substr(-4,4)=='.png' ||tl.substr(-4,4)=='.PNG' ||tl.substr(-4,4)=='.jpg' ||tl.substr(-4,4)=='.JPG' ||tl.substr(-5,5)=='.jpeg' ||tl.substr(-5,5)=='.JPEG' ||tl.substr(-4,4)=='.svg' ||tl.substr(-5,5)=='.webp' ||tl.substr(-5,5)=='.WEBP'){
                                                        imsource='file://'+rtx.text
                                                        codetab.insertTab(codetab.currentIndex+1,tl,imcomp)
                                                    }else{
                                                        codetab.insertTab(codetab.currentIndex+1,tl,cb)
                                                    }
                                                    //console.log()
                                                    backend.openfile(rtx.text)
                                                }
                                            }
                                        }
                                    }
                                }

                                ListModel{
                                    id:recmod
                                    
                                }

                                ScrollView{
                                    anchors.fill: parent
                                    ListView{
                                        id:rlist
                                        delegate:lcomp
                                        model:recmod
                                        clip:true
                                    }
                                    
                                }
                            }
                        }

                        Rectangle{
                            id:racourscis
                            //x:(parent.width/5)+recents.width+100
                            //y:recents.y
                            width:(parent.width/3)+30
                            height:parent.height-10
                            color:parent.color
                            anchors.right:parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.margins: 80

                            Rectangle{
                                width:parent.width
                                height:30
                                y:40
                                color:parent.color
                                Text{
                                    x:50
                                    text:qsTr('New file')
                                    color:'#1F4283'
                                    font.pixelSize:15
                                    font.italic:true
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Butts{
                                    x:140
                                    back_color:parent.color
                                    text_color:'#9B9FA5'
                                    butt_text:'crtl'
                                    //anchors.verticalCenter: parent.verticalCenter
                                }
                                Text{
                                    x:190
                                    text:'+'
                                    color:'#9B9FA5'
                                    font.pixelSize:14
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Butts{
                                    x:210
                                    back_color:parent.color
                                    text_color:'#9B9FA5'
                                    butt_text:'N'
                                    //anchors.verticalCenter: parent.verticalCenter
                                }
                            }

                            Rectangle{
                                width:parent.width
                                height:30
                                y:80
                                color:parent.color
                                Text{
                                    x:50
                                    text:qsTr('New folder')
                                    color:'#1F4283'
                                    font.pixelSize:15
                                    font.italic:true
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Butts{
                                    x:140
                                    back_color:parent.color
                                    text_color:'#9B9FA5'
                                    butt_text:'crtl'
                                    //anchors.verticalCenter: parent.verticalCenter
                                }
                                Text{
                                    x:190
                                    text:'+'
                                    color:'#9B9FA5'
                                    font.pixelSize:14
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Butts{
                                    x:210
                                    back_color:parent.color
                                    text_color:'#9B9FA5'
                                    butt_text:'K'
                                    //anchors.verticalCenter: parent.verticalCenter
                                }
                            }

                            Rectangle{
                                width:parent.width
                                height:30
                                y:120
                                color:parent.color
                                Text{
                                    x:50
                                    text:qsTr('Open folder')
                                    color:'#1F4283'
                                    font.pixelSize:15
                                    font.italic:true
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Butts{
                                    x:140
                                    back_color:parent.color
                                    text_color:'#9B9FA5'
                                    butt_text:'Alt'
                                    //anchors.verticalCenter: parent.verticalCenter
                                }
                                Text{
                                    x:190
                                    text:'+'
                                    color:'#9B9FA5'
                                    font.pixelSize:14
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Butts{
                                    x:210
                                    back_color:parent.color
                                    text_color:'#9B9FA5'
                                    butt_text:'Ctrl'
                                    //anchors.verticalCenter: parent.verticalCenter
                                }
                                Text{
                                    x:265
                                    text:'+'
                                    color:'#9B9FA5'
                                    font.pixelSize:14
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Butts{
                                    x:285
                                    back_color:parent.color
                                    text_color:'#9B9FA5'
                                    butt_text:'K'
                                    //anchors.verticalCenter: parent.verticalCenter
                                }
                            }

                            Rectangle{
                                width:parent.width
                                height:30
                                y:160
                                color:parent.color
                                Text{
                                    x:50
                                    text:qsTr('Open file')
                                    color:'#1F4283'
                                    font.pixelSize:15
                                    font.italic:true
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Butts{
                                    x:140
                                    back_color:parent.color
                                    text_color:'#9B9FA5'
                                    butt_text:'crtl'
                                    //anchors.verticalCenter: parent.verticalCenter
                                }
                                Text{
                                    x:190
                                    text:'+'
                                    color:'#9B9FA5'
                                    font.pixelSize:14
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Butts{
                                    x:210
                                    back_color:parent.color
                                    text_color:'#9B9FA5'
                                    butt_text:'O'
                                    //anchors.verticalCenter: parent.verticalCenter
                                }
                            }


                        }
                    }

                    Rectangle{
                        width:90
                        height:50
                        anchors.bottom:parent.bottom
                        anchors.right:parent.right
                        color:parent.color
                        anchors.margins: 2
                        
                        Image{
                            anchors.fill: parent
                            source:'../assets/icons/DotPy.png'
                        }
                    }
                }
                
            }
            // Tab{
            //     title: 'main.py'
            //     active: true
            //     //asynchronous: bool
            //     Rectangle{
            //         color:body.color
            //         anchors.fill: parent

            //         Rectangle{
            //             color:parent.color
            //             width:parent.width
            //             height:parent.height
            //             //x:60

            //             CodeEditor{
            //                 compcolor:barclaire
            //                 edit_height:parent.height-20
            //                 edit_width:parent.width-20
            //                 anchors.fill: parent
            //             }
            //         }
            //     }
            // }

            // Tab{
            //     title: 'main.kv'
            //     active: true
            //     //asynchronous: bool
            //     Rectangle{
            //         color:body.color
            //         anchors.fill: parent
                    
            //         CodeEditor{
            //             compcolor:barclaire
            //             edit_height:parent.height-20
            //             edit_width:parent.width-20
            //             anchors.fill: parent
            //         }
                    
            //     }
            // }
        }
    }
    Rectangle{
        id:terminal
        height:(parent.height/3)+50
        color:barclaire
        x:leftbar.width+leftbox.width
        width:parent.width-(leftbar.width+leftbox.width)
        border.color:bordercolor
        border.width:1
        anchors.bottom:parent.bottom
        visible:false

        UIText{
            anchors.left:parent.left
            anchors.margins: 50
            y:20
            text:'TERMINAL'
            font.pixelSize:15
            color:'white'
        }

        Rectangle{
            id:terferm
            width:30
            height:30
            radius:6
            color:parent.color
            anchors.top:parent.top
            anchors.right:parent.right
            anchors.margins: 15
            
            Text{
                id:xx
                anchors.centerIn: parent
                font.pixelSize:16
                color:'white'
                text:qsTr('×')
            }
            MouseArea{
                anchors.fill: parent
                hoverEnabled:true
                onEntered:{
                    xx.font.pixelSize=26
                }
                onExited:{
                    xx.font.pixelSize=16
                }
                onClicked:{
                    terminal.visible=false
                }
            }
        }

        Rectangle{
            id:xyw
            width:30
            height:30
            //anchors.top:parent.top
            y:terferm.y
            radius:6
            color:parent.color
            anchors.right:parent.right
            anchors.margins: 45
            
            Text{
                id:xxx
                anchors.centerIn: parent
                font.pixelSize:16
                color:'white'
                text:qsTr('^')
            }
            MouseArea{
                anchors.fill: parent
                hoverEnabled:true
                onEntered:{
                    xxx.font.pixelSize=26
                }
                onExited:{
                    xxx.font.pixelSize=16
                }
                onClicked:{
                    if(terminal.height<=(body.height/3)+50){
                        terminal.height=(body.height/2)+150
                    }else{
                        terminal.height=(body.height/3)+50
                    }
                }
            }
        }

        Rectangle{
            y:xyw.height+15
            width:parent.width-2
            height:parent.height-xyw.height-1
            color:parent.color
            anchors.horizontalCenter: parent.horizontalCenter
            // Terminal{
            //     id:minal
            //     //anchors.fill: parent
            // }
            Flickable{
                id:fkb
                anchors.fill: parent
                
                TextEdit{
                    id:txdt
                    font.pixelSize:14
                    font.family:'monospace'
                    width:parent.width
                    height:(lineCount*25)+100
                    //anchors.fill: parent
                    anchors.margins: 15
                    color:'#D6D4D3'
                    wrapMode:TextEdit.WordWrap
                    readOnly:true
                    Component.onCompleted:{//Keys.onReturnPressed:{
                        insert(cursorPosition,Terminal.spawn(['/bin/bash']))
                    }
                    Rectangle{
                        width:parent.width
                        height:35
                        anchors.bottom:parent.bottom
                        color:'transparent'
                        Text{
                            id:mintex
                            text:''
                            font.bold:true
                            font.pixelSize:14
                            font.family:'monospace'
                            color:'#044B85'
                            anchors.verticalCenter: parent.verticalCenter
                            Component.onCompleted:{
                                text=backend.terminal()
                            }
                        }
                        TextField{
                            y:2
                            x:mintex.width+5
                            width:parent.width-mintex.width
                            height:parent.height-10
                            //anchors.verticalCenter: parent.verticalCenter
                            background:Rectangle{
                                anchors.fill: parent
                                color:barclaire
                            }
                            color:'white'
                            font.pixelSize:15
                            font.family:'monospace'
                            topPadding:2
                            bottomPadding:4
                            Keys.onReturnPressed:{
                                txdt.insert(txdt.cursorPosition,backend.run_command(text))
                                text=''
                            }
                        }
                    }
                }
                ScrollBar.vertical: ScrollBar {
                    width:15
                    active: fkb.moving || !fkb.moving
                }
            }
        }

    }

    NumberAnimation{
        id:emu_off
        from: emmubox.x
        to: root.width
        duration: 200
        property: 'x'
        target:emmubox
       
    }
    NumberAnimation{
        id:emu_on
        from: root.width
        to: emmubox.x
        duration: 200
        property: 'x'
        target:emmubox
       
    }

    Rectangle{
        id:emmubox
        width:350
        z:10
        x:root.width
        y:top_bar.height
        height:parent.height-top_bar.height
        color:barclaire
        border.color:bordercolor
        border.width:1
        anchors.right:parent.right
        visible:false

        Rectangle{
            width:parent.width-40
            anchors.top:parent.top
            height:45
            border.width:1
            border.color:bordercolor
            color:parent.color
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle{
                height:parent.height-10
                width:35
                radius:7
                color:parent.color
                x:20
                anchors.verticalCenter: parent.verticalCenter
                
                Image{
                    height:20
                    width:20
                    anchors.centerIn: parent
                    source:'../assets/icons/run.png'
                }
                MouseArea{
                    anchors.fill: parent
                    hoverEnabled:true
                    onEntered:{
                        parent.color=hovercolor
                    }
                    onExited:{
                        parent.color=barclaire
                    }
                    onClicked:{
                        backend.emulator()
                        emloger.running=true
                    }
                }
            }
            Rectangle{
                height:parent.height-10
                width:35
                radius:7
                color:parent.color
                x:90
                anchors.verticalCenter: parent.verticalCenter
                
                Image{
                    height:20
                    width:20
                    anchors.centerIn: parent
                    source:'../assets/icons/ref.png'
                }
                MouseArea{
                    anchors.fill: parent
                    hoverEnabled:true
                    onEntered:{
                        parent.color=hovercolor
                    }
                    onExited:{
                        parent.color=barclaire
                    }
                    onClicked:{
                        
                    }
                }
            }
            Rectangle{
                height:parent.height-10
                width:35
                radius:7
                color:parent.color
                x:160
                anchors.verticalCenter: parent.verticalCenter
                
                Image{
                    height:20
                    width:20
                    anchors.centerIn: parent
                    source:'../assets/icons/hide.png'
                }
                MouseArea{
                    anchors.fill: parent
                    hoverEnabled:true
                    onEntered:{
                        parent.color=hovercolor
                    }
                    onExited:{
                        parent.color=barclaire
                    }
                    onClicked:{
                        emmubox.visible=false
                    }
                }
            }
                
            Rectangle{
                height:parent.height-10
                width:35
                radius:7
                color:parent.color
                x:230
                anchors.verticalCenter: parent.verticalCenter
                
                Image{
                    height:20
                    width:20
                    anchors.centerIn: parent
                    source:'../assets/icons/deco.png'
                }
                MouseArea{
                    anchors.fill: parent
                    hoverEnabled:true
                    onEntered:{
                        parent.color=hovercolor
                    }
                    onExited:{
                        parent.color=barclaire
                    }
                    onClicked:{
                        
                    }
                }
            }
        }
        
        Rectangle{
            width:350-20
            height:parent.height-47
            y:46
            color:parent.color
            anchors.horizontalCenter: parent.horizontalCenter

            Image{
                width:parent.width
                height:parent.height
                source:'../assets/images/em.png'
                visible:false
            }
            Column{
                anchors.fill:parent
                anchors.margins:5
                spacing:10
                Rectangle{
                    color:parent.parent.color
                    height: 40
                    width: parent.width
                    Text{
                        text:'Events Log'
                        color:'#FFFFFF'
                        font.pixelSize:16
                        anchors.centerIn:parent
                    }
                }
                Rectangle{
                    height: parent.height-50
                    width:parent.width
                    color:appcolor

                    Timer{
                        id:emloger
                        running:false
                        interval:5000
                        repeat:true
                        onTriggered:{
                            logmod.clear()
                            logmod.append(JSON.parse(obj.reparse(backend.emulationLog())))
                            loglist.positionViewAtEnd()
                        }
                    }
                    
                    //Component.onCompleted: backend.logEvent.connect(root.onLogEvent())

                    Component{
                        id:logdeg
                        Rectangle{
                            height: childrenRect.height+20//mlg.height+20
                            width: loglist.width
                            color:moyen
                            border.width:1
                            border.color:bordercolor
                            Row{
                                anchors.fill:parent
                                spacing: 10
                                anchors.margins:2
                                Rectangle{
                                    height: parent.height-20
                                    width: height
                                    color:parent.parent.color
                                    anchors.verticalCenter:parent.verticalCenter
                                    Image{
                                        anchors.fill:parent
                                        source:''
                                    }
                                }
                                Rectangle{
                                    height: childrenRect.height
                                    width: parent.width-50
                                    color:moyen
                                    anchors.verticalCenter:parent.verticalCenter
                                    Text{
                                        id:mlg
                                        text: msg
                                        color:'#CCCCCC'
                                        font.pixelSize:10
                                        wrapMode: Text.WordWrap
                                        width:parent.width
                                        height: parent.height
                                        lineHeight: 15
                                        anchors.verticalCenter:parent.verticalCenter
                                    }
                                }
                            }
                        }
                    }
                    ListModel{
                        id:logmod
                    }

                    ScrollView{
                        anchors.fill:parent
                        ListView{
                            id:loglist
                            anchors.fill:parent
                            spacing:5
                            clip:true
                            model:logmod
                            delegate: logdeg
                        }
                    }
                }
            }
        }
    }

    Component{
        id:codebox
        Rectangle{
            color:root.color
            property alias furl:nfc.link
            property alias codealias:nfc.code
            CodeEditor{
                id:nfc
                compcolor:barclaire
                edit_height:parent.height
                edit_width:parent.width
                anchors.fill: parent
                //code:''
                
            }
            Component.onCompleted:{
                nfc.link=lnk
            }
            // Shortcut {
            //     sequence: "Ctrl+S"
            //     onActivated: {
            //         console.log('saving file...')
            //         cde=nfc.scode.getText(0,nfc.code.length)
            //         //console.log(cde)
            //         backend.savefile(fm.folder.toString(),codetab.getTab(codetab.currentIndex).title,cde)
            //         //cde=''
            //     }
            // }
        }
    }
    Component{
        id:cb
        Rectangle{
            color:root.color
            width:codetab.width
            height:codetab.height
            property alias cd:ce.scode
            property alias lk:ce.link
            CodeEditor{
                id:ce
                compcolor:barclaire
                edit_height:parent.height
                edit_width:parent.width
                anchors.fill: parent
                //code:text
            }
            Component.onCompleted:{
                ce.code=qsTr(cde).replace('\n\r',qsTr('\n'))
                ce.link=lnk
                //console.log(ce.link)
            }
            
        }
    }

    FileOpenDialog{
        id:fileop
        anchors.centerIn: parent
        visible:false
        theme_color:barclaire
        border_color:bordercolor
        Keys.onReturnPressed:{
            visible=false
            if(root.currentFolder==''){
                root.currentFolder=fm.folder
            }
            backend.newfile(fileop.get_filename,root.currentFolder.toString())
            lnk=root.currentFolder.toString()+fileop.get_filename.toString()
            codetab.insertTab(codetab.currentIndex+1,fileop.get_filename,codebox)
        }
    }
    FileOpenDialog{
        id:foldn
        anchors.centerIn: parent
        visible:false
        theme_color:barclaire
        border_color:bordercolor
        message:'Create new folder'
        field.placeholderText:'foldername'
        Keys.onReturnPressed:{
            visible=false
            //console.log()
            backend.newfolder(foldn.get_filename,root.currentFolder.toString())
            //codetab.addTab(fileop.get_filename,cb)
        }
    }

    FileDialog{
        id:opfile
        defaultSuffix: '*.py'
        //fileUrl: url
        //fileUrls: list<url>
        folder: shortcuts.home
        //modality: Qt: : WindowModality
        nameFilters: ["All files (*)"]
        selectExisting: true
        selectFolder: false
        selectMultiple: false
        //selectedNameFilter: string
        //shortcuts: Object
        //sidebarVisible: bool
        title: 'Open file'
        //visible: bool
        onAccepted:{
            var text=backend.openfile(fileUrl)
            var titre=backend.get_filename(fileUrl)
            cde=text
            lnk=fileUrl.toString()
            codetab.insertTab(codetab.currentIndex+1, titre,cb)
            //root.setcode(text)
        }
    }
    FileDialog{
        id:opfold
        defaultSuffix: '*.py'
        //fileUrl: url
        //fileUrls: list<url>
        folder: shortcuts.home
        //modality: Qt: : WindowModality
        nameFilters: ["All files (*)"]
        selectExisting: true
        selectFolder: true
        selectMultiple: true
        //selectedNameFilter: string
        //shortcuts: Object
        //sidebarVisible: bool
        title: 'Open folder'
        //visible: bool
        onAccepted:{
            var text=opfold.fileUrl
            //console.log(text.toString())//.substr(6,text.length-6))
            //tmod.clear()
            fm.folder=text.toString()//.substr(6,text.length-6)
            fm.show()
        }
    }

    FileDialog{
        id:plugdialog
        defaultSuffix: '*.py'
        //fileUrl: url
        //fileUrls: list<url>
        folder: shortcuts.home
        //modality: Qt: : WindowModality
        nameFilters: ["All files (*)"]
        selectExisting: true
        selectFolder: true
        selectMultiple: true
        //selectedNameFilter: string
        //shortcuts: Object
        sidebarVisible: true
        title: 'Choose Plugin folder to install'
        //visible: bool
        onAccepted:{
            var text=fileUrl
            //console.log(text.toString())//.substr(6,text.length-6))
            loading.visible=true
            timer.running=true
            var r=backend.installPlugin(text);
        }
    }
    Timer{
        id: timer
        running: false
        repeat: false
        interval:3000

        onTriggered: loading.visible=false;
    }

    Rectangle{
        id:loading
        height:110
        width:320
        border.width:1
        border.color:bordercolor
        color:barclaire
        anchors.centerIn:parent
        visible:false
        property string msgt:'please wait until the installation'
        Row{
            anchors.fill:parent
            anchors.margins:10
            spacing:15
            Rectangle{
                color:parent.parent.color
                height:parent.height
                width:height//(parent.parent.width/4)-15
                anchors.verticalCenter: parent.verticalCenter
                AnimatedImage{
                    anchors.fill:parent
                    source:'../assets/images/load.gif'
                }
            }
            Rectangle{
                color:parent.parent.color
                height:parent.height
                width:parent.width-height-15//((parent.width*3)/4)-15
                anchors.verticalCenter: parent.verticalCenter
                
                Text{
                    id:insmsg
                    text:loading.msgt
                    color:'white'
                    font.pixelSize:11
                    anchors.centerIn:parent
                }
            }
        }
    }

    Dialog{
        id:newproj
        height: 450
        width: 700
        title: 'new project'
        contentItem:NewProject{
            anchors.fill:parent
            onCanceled:{
                newproj.close()
            }
        }
        standardButtons: StandardButton.Cancel| StandardButton.Ok
    }
}
