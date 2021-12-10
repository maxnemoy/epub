import 'package:flutter/material.dart';
import 'package:slide_panel/slide_panel/controller.dart';

class SlidePanel extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget child;
  final Color backgroundColor;
  final Color accentColor;
  final TextStyle titleTextStyle;
  final SlidePanelController controller;
  SlidePanel({ Key? key, 
  required this.title, 
  required this.body, 
  required this.child, 
  this.backgroundColor = Colors.white, 
  this.accentColor = Colors.orange,
  SlidePanelController? controller, 
  TextStyle? titleTextStyle
  }) :
  controller = controller ?? SlidePanelController(),
  titleTextStyle = titleTextStyle ?? TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: accentColor),
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: StreamBuilder<bool>(
          stream: controller.isShow,
          initialData: false,
          builder: (context, snapshot) => Stack(
            children: [
              child,
              if(snapshot.data ?? false)
              GestureDetector(onTap: (){
                controller.hidePanel();
              },  child: Container(width: double.infinity, height: double.infinity, color: Colors.grey.withOpacity(0.6),)),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                bottom: snapshot.data ?? false ? 0 : -MediaQuery.of(context).size.height,
                child: GestureDetector(
                  onVerticalDragEnd: (detail){
                    if(detail.primaryVelocity != null && detail.primaryVelocity! > 10){
                        controller.hidePanel();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                      ),
                    width: MediaQuery.of(context).size.width,                
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Container(
                              height: 5,
                              width: 40,
                              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: const BorderRadius.all(Radius.circular(2))),
                            )],),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 25, left: 40, bottom: 20),
                            child: Text(title, style: titleTextStyle,),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: Container(color: accentColor, height: 2, width: double.infinity,),
                          ),
                          ConstrainedBox(                      
                            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height*.8),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 60, right: 10, bottom: 35),
                              child: SingleChildScrollView(child: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: IntrinsicHeight(child: body),
                              )),
                            )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}