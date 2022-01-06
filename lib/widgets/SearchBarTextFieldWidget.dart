import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jingyaoyun/base/base_store_state.dart';

class SearchBarTextFieldWidget extends StatefulWidget {
  final String barTitle;
  final double radius;
  final Function(String) textChangeLinster;
  SearchBarTextFieldWidget({Key key, this.barTitle="", this.radius=0, this.textChangeLinster}) : super(key: key);

  @override
  _SearchBarTextFieldWidgetState createState() => _SearchBarTextFieldWidgetState();
}

class _SearchBarTextFieldWidgetState extends BaseStoreState<SearchBarTextFieldWidget> {
  
  TextEditingController _textEditingController;
  @override
  void initState() { 
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return _body();
  }
  _body(){
    Color greyColor = Colors.grey;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
        color: Colors.white,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.centerLeft,
              // child: Text(widget.barTitle, style: TextStyle(color: greyColor, fontSize: 12,),),
              child: CupertinoTextField(
                onEditingComplete: (){
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (widget.textChangeLinster!=null) {
                    widget.textChangeLinster(_textEditingController.text);
                  }
                },
                onChanged: (string){
                  
                },
                controller: _textEditingController,
                placeholder: widget.barTitle,
                placeholderStyle: TextStyle(color: greyColor, fontSize: 12,),
                decoration: BoxDecoration(
                ),
                maxLines: 1,
                style: TextStyle(fontSize: 13, color: Colors.black),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Image.asset('assets/home_tab_search.png', width: 17, height: 17, color: Colors.grey,),
          Container(width: 17,),
        ],
      ),
    );
  }
}
