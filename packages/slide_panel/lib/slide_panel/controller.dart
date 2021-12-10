import 'dart:async';

class SlidePanelController{
  final StreamController<bool> _isShow = StreamController<bool>(); 
  bool _currentState = false;

  Stream<bool> get isShow => _isShow.stream; 
  bool get currentState => _currentState;

  void dispose(){
    _isShow.close();
  }

  void showPanel(){
    _currentState = true;
    _isShow.add(_currentState);
  }

  void hidePanel(){
    _currentState = false;
    _isShow.add(_currentState);
  }
}