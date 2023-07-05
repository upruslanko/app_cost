import 'package:flutter/material.dart';

class ViewPage extends StatelessWidget {
  final int activePage;
  final int itemsCount;

  ViewPage(this.itemsCount, this.activePage);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 25),
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
          itemsCount,
          (index) => viewEntity(index, activePage),
        ),
      ),
    );
  }

  Widget viewEntity(currentPage, activePage) {
    return Container(
      width: 20,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: (currentPage == activePage) ? Colors.red : Colors.white),
    );
  }
}
