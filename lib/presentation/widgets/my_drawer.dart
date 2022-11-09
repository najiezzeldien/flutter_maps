import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_tut/business_logic/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:flutter_maps_tut/constants/my_color.dart';
import 'package:flutter_maps_tut/constants/my_strings.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});
  PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit();
  Widget buildDrawerHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(
            70,
            10,
            70,
            10,
          ),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.blue[100],
          ),
          child: Image.asset(
            "assets/images/naji.jpg",
            fit: BoxFit.cover,
          ),
        ),
        const Text(
          "Naji Ezzeldien",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        BlocProvider<PhoneAuthCubit>(
          create: (context) => phoneAuthCubit,
          child: Text(
            "${phoneAuthCubit.getLoggedInUser().phoneNumber}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }

  Widget buildDrawerListItem({
    required IconData leadingIcon,
    required String title,
    Widget? trailing,
    Function()? onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(
        leadingIcon,
        color: color ?? MyColors.blue,
      ),
      title: Text(title),
      trailing: trailing ??
          const Icon(
            Icons.arrow_right,
            color: MyColors.blue,
          ),
      onTap: onTap,
    );
  }

  Widget buildDrawerListItemDivider() {
    return const Divider(
      height: 0,
      thickness: 1,
      indent: 24,
    );
  }

  void _launchURL(String url) async {
    await canLaunchUrl(Uri.parse(url))
        ? launch(url)
        : throw "Could not launch $url";
  }

  Widget buildIcon(IconData icon, String url) {
    return InkWell(
      onTap: () => _launchURL(url),
      child: Icon(
        icon,
        color: MyColors.blue,
        size: 35,
      ),
    );
  }

  Widget buildSocialMediaIcons() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 16),
      child: Row(
        children: [
          buildIcon(FontAwesomeIcons.facebook,
              "https://www.facebook.com/naji.izaldeen/"),
          const SizedBox(
            width: 15,
          ),
          buildIcon(FontAwesomeIcons.youtube,
              "https://www.youtube.com/channel/UCvBFJUZC2YHHf3LS2Kc1hOw/featured"),
          const SizedBox(
            width: 20,
          ),
          buildIcon(FontAwesomeIcons.telegram, "https://t.me/NajiEzzeldien"),
        ],
      ),
    );
  }

  Widget buildLogoutBlocProvider(BuildContext context) {
    return SizedBox(
      child: BlocProvider<PhoneAuthCubit>(
        create: (context) => phoneAuthCubit,
        child: buildDrawerListItem(
            leadingIcon: Icons.logout,
            title: "Logout",
            onTap: () async {
              await phoneAuthCubit.logOut();
              Navigator.of(context).pushReplacementNamed(loginScreen);
            },
            color: Colors.red,
            trailing: const SizedBox()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 280,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue[100]),
              child: buildDrawerHeader(context),
            ),
          ),
          buildDrawerListItem(
            leadingIcon: Icons.person,
            title: "My Profile",
          ),
          buildDrawerListItemDivider(),
          buildDrawerListItem(
            leadingIcon: Icons.history,
            title: "Places History",
            onTap: () {},
          ),
          buildDrawerListItemDivider(),
          buildDrawerListItem(
            leadingIcon: Icons.settings,
            title: "Settings",
          ),
          buildDrawerListItemDivider(),
          buildDrawerListItem(
            leadingIcon: Icons.help,
            title: "Help",
          ),
          buildDrawerListItemDivider(),
          buildLogoutBlocProvider(context),
          const SizedBox(
            height: 180,
          ),
          ListTile(
            leading: Text(
              "Follow us",
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
          buildSocialMediaIcons(),
        ],
      ),
    );
  }
}
