/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-07-05  14:32 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';

class EmptyView {
  static Widget goodsDetailEmptyView() {
    return ListView(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            color: AppColor.tableViewGrayColor,
          ),),
       Container(
         color: Colors.white,
         height: 150,
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: <Widget>[
             borderContainer(
               margin: EdgeInsets.only(top: 15, left: 10, right: 10),
               height: 18,
               width: 150,
               color: Color.fromARGB(255, 252, 221, 206),
             ),

             Row(
               children: <Widget>[
                 Expanded(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: <Widget>[
                       borderContainer(
                         margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                         height: 13,
                         width: 100,
                         color: AppColor.tableViewGrayColor,
                       ),
                       borderContainer(
                         margin: EdgeInsets.only(right: 80,left: 10, bottom: 8),
                         height: 20,
                         color: AppColor.tableViewGrayColor,
                       ),

                     ],
                   ),
                 ),

                 borderContainer(
                   width: 50,
                   height: 18,
                   color: AppColor.tableViewGrayColor
                 )
               ],
             ),
             borderContainer(
               height: 16,
               margin: EdgeInsets.only(right: 160,left: 10, bottom: 8),
               color: AppColor.tableViewGrayColor,
             ),
             Expanded(
               child: Container(
                 padding: EdgeInsets.symmetric(horizontal: 20),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: <Widget>[
                     borderContainer(
                       width: 60,
                       height: 16,
                       color: AppColor.tableViewGrayColor
                     ),
                     borderContainer(
                         width: 60,
                         height: 16,
                         color: AppColor.tableViewGrayColor
                     ),
                     borderContainer(
                         width: 60,
                         height: 16,
                         color: AppColor.tableViewGrayColor
                     ),
                     borderContainer(
                         width: 60,
                         height: 16,
                         color: AppColor.tableViewGrayColor
                     )
                   ],
                 ),
               ),
             )
           ],
         ),
       ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 15),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          color: Colors.white,
          height: 100,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  borderContainer(
                    height: 16,
                    width: 40,
                    color: AppColor.tableViewGrayColor
                  ),
                  borderContainer(
                    margin: EdgeInsets.only(left: 20),
                    height: 16,
                    width: 240,
                    color: AppColor.tableViewGrayColor
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Row(
                  children: <Widget>[
                    borderContainer(
                      height: 16,
                      width: 40,
                      color: AppColor.tableViewGrayColor
                    ),
                    borderContainer(
                      margin: EdgeInsets.only(left: 20),
                      height: 16,
                      width: 160,
                      color: AppColor.tableViewGrayColor
                    ),
                  ],
                ),
              ),
            ],
          ),
        )  ,
        Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          color: Colors.white,
          height: 100,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  borderContainer(
                    height: 16,
                    width: 40,
                    color: AppColor.tableViewGrayColor
                  ),
                  borderContainer(
                    margin: EdgeInsets.only(left: 20),
                    height: 16,
                    width: 240,
                    color: AppColor.tableViewGrayColor
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Row(
                  children: <Widget>[
                    borderContainer(
                      height: 16,
                      width: 160,
                      color: AppColor.tableViewGrayColor
                    ),
                    borderContainer(
                      margin: EdgeInsets.only(left: 20),
                      height: 16,
                      width: 40,
                      color: AppColor.tableViewGrayColor
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  static Container borderContainer({Widget? child,double? width, double? height,Color? color, EdgeInsetsGeometry? margin}) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(7))
      ),
      child: child,
    );
  }

}
