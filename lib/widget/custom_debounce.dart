import 'dart:async';

class CustomDebounce {

  dispose(){
    _timer?.cancel();
  }

  Timer? _timer;

  onChange(void Function() onFunction){
    if (_timer?.isActive ?? false) _timer!.cancel();
    _timer = Timer(const Duration(milliseconds: 500), onFunction);
  }
}