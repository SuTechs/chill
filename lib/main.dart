import 'package:chill/widgets/custom_divided_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chill',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}

class RotatedText extends StatelessWidget {
  final bool selected;
  final String text;

  const RotatedText({Key key, this.selected = false, @required this.text})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 1,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Opacity(
            opacity: selected ? 1 : 0,
            child: Text(
              '• ',
              style: TextStyle(
                color: Colors.red,
                fontSize: 30,
              ),
            ),
          ),
          Text(text),
        ],
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: VerticalTabHome(
        tabs: ['Forest', 'Rain', 'Fire'],
        initialIndex: 1,
        contents: [
          Text('Hello'),
          Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    for (int i = 0; i < 20; i++)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            color: Colors.green,
                            height: 50,
                          ),
                          Container(
                            color: Colors.red,
                            height: 50,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              Container(
                color: Colors.blue,
                height: 500,
              )
            ],
          ),
          Container(
            color: Colors.green,
          ),
        ],
      )),
    );
  }
}

class VerticalTabHome extends StatefulWidget {
  final List<String> tabs;
  final int initialIndex;
  final List<Widget> contents;

  const VerticalTabHome(
      {Key key, this.tabs, this.initialIndex = 0, this.contents})
      : assert(
            tabs != null && contents != null && tabs.length == contents.length),
        super(key: key);

  @override
  _VerticalTabHomeState createState() => _VerticalTabHomeState();
}

class _VerticalTabHomeState extends State<VerticalTabHome>
    with TickerProviderStateMixin {
  int _selectedIndex;
  final PageController _pageController = PageController();

  @override
  void initState() {
    _selectedIndex = widget.initialIndex;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController.jumpToPage(widget.initialIndex);
      _selectTab(widget.initialIndex);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDividedScreen(
      minSideChild: Column(
        children: [
          Hero(
            tag: '005500',
            child: Material(
              color: Colors.transparent,
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DetailScreen()),
                ),
              ),
            ),
          ),
          Expanded(child: _tabs()),
        ],
      ),
      maxSideChild: PageView.builder(
        scrollDirection: Axis.vertical,
        physics: AlwaysScrollableScrollPhysics(),
        onPageChanged: (index) {
          _selectTab(index);
        },
        controller: _pageController,
        itemCount: widget.contents.length,
        itemBuilder: (BuildContext context, int index) {
          return widget.contents[index];
        },
      ),
    );
  }

  Widget _tabs() {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity < 0) _goToPage(_selectedIndex + 1);
        if (details.primaryVelocity > 0) _goToPage(_selectedIndex - 1);
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (int index = 0; index < widget.tabs.length; index++)
              InkWell(
                onTap: () => _goToPage(index),
                child: RotatedText(
                  text: widget.tabs[index],
                  selected: _selectedIndex == index,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _selectTab(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _goToPage(int index) {
    if (index == widget.tabs.length || index < 0) return;
    _selectTab(index);
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }
}

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomDividedScreen(
          maxSizeSide: MaxSizeSide.Left,
          minSideChild: Container(),
          maxSideChild: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: SizedBox(),
                  ),
                  Expanded(
                    flex: 1,
                    child: Hero(
                      tag: '005500',
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                color: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
