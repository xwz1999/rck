import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final String? barTitle;
  final double? radius;
  const SearchBarWidget({Key? key, this.barTitle, this.radius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _body(),
    );
  }

  _body(){
    Color greyColor = Colors.grey;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius!)),
        color: Colors.white,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.centerLeft,
              child: Text(barTitle!, style: TextStyle(color: greyColor, fontSize: 12,),),
            ),
          ),
          Image.asset('assets/home_tab_search.png', width: 17, height: 17, color: Colors.grey,),
          Container(width: 17,),
        ],
      ),
    );
  }


}
