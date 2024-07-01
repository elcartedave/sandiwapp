import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sandiwapp/components/orgNavigator.dart';
import 'package:sandiwapp/screens/users/organization/announcements/OrgAnnouncement.dart';
import 'package:sandiwapp/screens/users/organization/OrgEvents.dart';
import 'package:sandiwapp/screens/users/organization/OrgForms.dart';
import 'package:sandiwapp/screens/users/organization/OrgResidents.dart';
import 'package:sandiwapp/screens/users/organization/overview/Overview.dart';

class OrgDashboard extends StatefulWidget {
  const OrgDashboard({super.key});

  @override
  State<OrgDashboard> createState() => _OrgDashboardState();
}

class _OrgDashboardState extends State<OrgDashboard> {
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  String clicked = "Overview";
  int selectedIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    int previousIndex = selectedIndex;
    setState(() {
      selectedIndex = index;
      clicked = _getLabelFromIndex(index);
    });

    if ((previousIndex - index).abs() == 1) {
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _pageController.jumpToPage(index);
    }

    // Scroll to the selected OrgNavigator button
    _scrollToSelectedButton(index);
  }

  void _scrollToSelectedButton(int index) {
    double offset = (index * 120.0) -
        (_scrollController.position.viewportDimension / 2) +
        60.0;
    _scrollController.animateTo(offset,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  String _getLabelFromIndex(int index) {
    switch (index) {
      case 0:
        return "Overview";
      case 1:
        return "Announcements";
      case 2:
        return "Events/GA";
      case 3:
        return "Forms";
      case 4:
        return "Residents";
      default:
        return "Overview";
    }
  }

  int _getIndexFromLabel(String label) {
    switch (label) {
      case "Overview":
        return 0;
      case "Announcements":
        return 1;
      case "Events":
        return 2;
      case "Forms":
        return 3;
      case "Residents":
        return 4;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          opacity: 0.7,
          image: AssetImage("assets/images/bg1.png"),
          fit: BoxFit.cover,
        ),
      ),
      padding:
          const EdgeInsets.only(left: 16.0, right: 8.0, top: 0.0, bottom: 8.0),
      child: Column(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                OrgNavigator(
                  label: "Overview",
                  onTap: () => _onItemTapped(0),
                  clicked: clicked,
                ),
                const SizedBox(width: 10),
                OrgNavigator(
                  label: "Announcements",
                  onTap: () => _onItemTapped(1),
                  clicked: clicked,
                ),
                const SizedBox(width: 10),
                OrgNavigator(
                  label: "Events/GA",
                  onTap: () => _onItemTapped(2),
                  clicked: clicked,
                ),
                const SizedBox(width: 10),
                OrgNavigator(
                  label: "Forms",
                  onTap: () => _onItemTapped(3),
                  clicked: clicked,
                ),
                const SizedBox(width: 10),
                OrgNavigator(
                  label: "Residents",
                  onTap: () => _onItemTapped(4),
                  clicked: clicked,
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              physics: RangeMaintainingScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  selectedIndex = index;
                  clicked = _getLabelFromIndex(index);
                });
                _scrollToSelectedButton(index);
              },
              children: [
                OrgOverview(),
                OrgAnnouncement(),
                OrgEvents(),
                OrgForms(),
                OrgResidents(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
