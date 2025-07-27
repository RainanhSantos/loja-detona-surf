import 'package:flutter/material.dart';

class PageManeger {

  PageManeger(this._pageController);

  final PageController _pageController;

  int page = 0;

  void setPage(int value) {
    if (value == page) return;

    if (!_pageController.hasClients) {
      debugPrint('PageController ainda não está conectado ao PageView.');
      return;
    }

    page = value;
    _pageController.jumpToPage(value);
  }


}
