import 'dart:async';

import 'package:daily_purify/model/menu_model.dart';
import 'package:daily_purify/widget/common_snakeBar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<ScaffoldState> registKey = new GlobalKey();

  String _phoneNum = '';

  String _verifyCode = '';

  int _seconds = 0;

  String _verifyStr = '获取验证码';

  Timer _timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _cancelTimer();
  }

  _startTimer() {
    _seconds = 10;

    _timer = new Timer.periodic(new Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        _cancelTimer();
        return;
      }

      _seconds--;
      _verifyStr = '$_seconds(s)';
      setState(() {});
      if (_seconds == 0) {
        _verifyStr = '重新发送';
      }
    });
  }

  _cancelTimer() {
    _timer?.cancel();
  }

  Widget _buildCustomBar() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, //子组件的排列方式为主轴两端对齐
      children: <Widget>[
        new InkWell(
          child: new Padding(
              padding: const EdgeInsets.all(12.0),
              child: new Icon(
                Icons.clear,
                size: 26.0,
                color: Colors.grey[700],
              )),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        new InkWell(
          child: new Padding(
              padding: const EdgeInsets.all(12.0),
              child: new Text(
                "密码登录",
                style: new TextStyle(fontSize: 16.0, color: Colors.grey[700]),
              )),
          onTap: () {
            showTips();
          },
        ),
      ],
    );
  }

  Widget _buildPhoneEdit() {
    var node = new FocusNode();
    return new Padding(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0),
      child: new TextField(
        onChanged: (str) {
          _phoneNum = str;
          setState(() {});
        },
        decoration: new InputDecoration(
          hintText: '请输入手机号',
        ),
        maxLines: 1,
        maxLength: 11,
        //键盘展示为号码
        keyboardType: TextInputType.phone,
        //只能输入数字
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly,
        ],
        onSubmitted: (text) {
          FocusScope.of(context).reparentIfNeeded(node);
        },
      ),
    );
  }

  Widget _buildVerifyCodeEdit() {
    var node = new FocusNode();
    Widget verifyCodeEdit = new TextField(
      onChanged: (str) {
        _verifyCode = str;
        setState(() {});
      },
      decoration: new InputDecoration(
        hintText: '请输入短信验证码',
      ),
      maxLines: 1,
      maxLength: 6,
      //键盘展示为数字
      keyboardType: TextInputType.number,
      //只能输入数字
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter.digitsOnly,
      ],
      onSubmitted: (text) {
        FocusScope.of(context).reparentIfNeeded(node);
      },
    );

    Widget verifyCodeBtn = new InkWell(
      onTap: (_seconds == 0)
          ? () {
              setState(() {
                _startTimer();
              });
            }
          : null,
      child: new Container(
        alignment: Alignment.center,
        width: 100.0,
        height: 36.0,
        decoration: new BoxDecoration(
          border: new Border.all(
            width: 1.0,
            color: Colors.blue,
          ),
        ),
        child: new Text(
          '$_verifyStr',
          style: new TextStyle(fontSize: 14.0),
        ),
      ),
    );

    return new Padding(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
      child: new Stack(
        children: <Widget>[
          verifyCodeEdit,
          new Align(
            alignment: Alignment.topRight,
            child: verifyCodeBtn,
          ),
        ],
      ),
    );
  }

  Widget _buildLabel() {
    return new Container(
      margin: const EdgeInsets.only(top: 40.0, bottom: 20.0),
      alignment: Alignment.center,
      child: new Text(
        "登录知乎日报，体验更多功能",
        style: new TextStyle(fontSize: 24.0),
      ),
    );
  }

  Widget _buildRegist() {
    return new Padding(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 20.0),
      child: new RaisedButton(
        color: Colors.blue,
        textColor: Colors.white,
        disabledColor: Colors.blue[100],
        onPressed: (_phoneNum.isEmpty || _verifyCode.isEmpty) ? null : () {
          showTips();
        },
        child: new Text(
          "登  录",
          style: new TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  Widget _buildTips() {
    return new Padding(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 20.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, //子组件的排列方式为主轴两端对齐
        children: <Widget>[
          new Text(
            "未注册手机验证后自动登录",
            style: new TextStyle(fontSize: 14.0, color: Colors.grey[500]),
          ),
          new Text(
            "需要帮助",
            style: new TextStyle(fontSize: 14.0, color: Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget _buildThirdPartLogin() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: menus_login.map((Menu m) {
        return new GestureDetector(
          onTap: () {
            switch (m.index) {
              case 0:
                CommonSnakeBar.buildSnakeBarByKey(registKey, context, '点击了微信');
                break;
              case 1:
                CommonSnakeBar.buildSnakeBarByKey(
                    registKey, context, '点击了新浪微博');
                break;
            }
          },
          child: new Padding(
              padding: const EdgeInsets.only(
                  left: 24.0, top: 60.0, bottom: 12.0, right: 24.0),
              child: new Image.asset(
                m.icon,
                width: 60.0,
                height: 60.0,
              )),
        );
      }).toList(),
    );
  }

  Widget _buildProtocol() {
    return new Padding(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0,bottom: 20.0),
      child: new Container(
        child: new Text.rich(
          new TextSpan(
              text: '注册知乎日报代表你已阅读并同意 ',
              style: new TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w400),
              children: [
                new TextSpan(
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () {
                        CommonSnakeBar.buildSnakeBarByKey(
                            registKey, context, '点击了知乎协议');
                      },
                    text: '知乎协议',
                    style: new TextStyle(
                      fontSize: 14.0,
                      color: Colors.blue,
                      fontWeight: FontWeight.w400,
                    )),
                new TextSpan(
                    text: ' 和 ',
                    style: new TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w400,
                    )),
                new TextSpan(
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () {
                        CommonSnakeBar.buildSnakeBarByKey(
                            registKey, context, '点击了隐私政策');
                      },
                    text: '隐私政策',
                    style: new TextStyle(
                      fontSize: 14.0,
                      color: Colors.blue,
                      fontWeight: FontWeight.w400,
                    )),
              ]),
        ),
      ),
    );
  }

  Widget _buildBody(){
    return new ListView(
      children: <Widget>[
        _buildCustomBar(),
        _buildLabel(),
        _buildPhoneEdit(),
        _buildVerifyCodeEdit(),
        _buildRegist(),
        _buildTips(),
        _buildThirdPartLogin(),
        _buildProtocol(),
      ],
    );
  }


  showTips() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return new Container(
              child: new Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: new Text('没有相关接口，这是一个纯UI界面，提供部分交互体验',
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 24.0))));
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Scaffold(
        key: registKey,
        backgroundColor: Colors.white,
        body: _buildBody(),
      ),
    );
  }
}

