import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{

  Animation animation;
  AnimationController _animationController;
  IconData icon = Icons.arrow_back_ios;
  bool right = false;
  var radius = BorderRadius.only(topLeft: Radius.circular(20));
  var align = Alignment.centerLeft;
  bool reverse = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 750)
    )..addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          icon = Icons.arrow_forward_ios;
          right = !right;
          radius = BorderRadius.only(topRight: Radius.circular(20));
          align = Alignment.centerRight;
          reverse = true;
        });
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
          icon = Icons.arrow_back_ios;
          radius = BorderRadius.only(topLeft: Radius.circular(20));
          align = Alignment.centerLeft;
          reverse = false;
        });
      }
    });

    animation = new Tween(
      begin: 0,
      end: 1.0,
    ).animate(new CurvedAnimation(
        parent: _animationController,
        curve: SineCurve()
    ));
  }

  void toggle(){
    _animationController.isDismissed
        ? _animationController.forward()
        :_animationController.reverse();
  }



  @override
  Widget build(BuildContext context) {

    double maxSlide = MediaQuery.of(context).size.width;
    bool _canBeDragged;
    var profile = Container(
      color: Colors.blueAccent,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: (){
          Navigator.of(context).pushNamed("/text");
        },
        child: Text("Profile")
      ),
    );
    var explore = Container(
      color: Colors.yellow,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Text("Explore"),
    );

    void _onDragStart(DragStartDetails details) {
      bool isDragOpenFromLeft = _animationController.isDismissed;
      bool isDragCloseFromRight = _animationController.isCompleted;
      _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
    }

    void _onDragUpdate(DragUpdateDetails details) {
      if (_canBeDragged) {
        double delta = details.primaryDelta / maxSlide;
        _animationController.value -= delta;
      }
    }

    void _onDragEnd(DragEndDetails details) {
      //I have no idea what it means, copied from Drawer
      double _kMinFlingVelocity = 365.0;

      if (_animationController.isDismissed || _animationController.isCompleted) {
        return;
      }
      if(reverse){
        if (_animationController.value < 0.75) {
          _animationController.reverse();
        } else {
          _animationController.forward();
        }
      }else{
        if (_animationController.value > 0.25) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      }
    }

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (context,_){
                double slide = maxSlide*_animationController.value;
                return Stack(
                  children: [
                    Transform(
                        transform: Matrix4.identity()..translate(-slide),
                        child: profile
                    ),
                    Transform.translate(
                      offset: Offset(maxSlide*(1-_animationController.value),0),
                      child: explore,
                    ),
                  ],
                );
              },
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: animation,
                builder: (context,_){
                  double slide = animation.value==1?0:(maxSlide-64)*animation.value;
                  print(animation.value);
                  return GestureDetector(
                    onTap: toggle,
                    onHorizontalDragStart: _onDragStart,
                    onHorizontalDragUpdate: _onDragUpdate,
                    onHorizontalDragEnd: _onDragEnd,
                    child: Container(
                      alignment: align,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      margin: !_animationController.isCompleted
                        ?_animationController.value>0.5
                          ?EdgeInsets.only(right: maxSlide-slide-64)
                          :EdgeInsets.only(right: 0)
                        :EdgeInsets.only(right: maxSlide-64)
                      ,
                      decoration: BoxDecoration(
                        borderRadius: radius,
                        color: Colors.white,
                      ),

                      width: animation.isCompleted?64:slide+64,
                      height: 48,
                      child: Icon(
                          icon
                      ),
                    ),
                  );
                },
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}

class SineCurve extends Curve {
  // t = x
  final double count;

  SineCurve({this.count = 1});

  @override
  double transformInternal(double t) {
    var val = t<0.5
        ? 2*t
        : 2-2*t;
    return val; //f(x)
  }
}
