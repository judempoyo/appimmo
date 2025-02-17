import 'package:appimmo/src/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutUsPage extends StatelessWidget {
  static const routeName = '/about';

  final SettingsController settingsController;

  const AboutUsPage({super.key, required this.settingsController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'À propos de nous',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: settingsController.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Bienvenue dans APPIMMO !',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: settingsController.primaryColor),
              ),
              const SizedBox(height: 20),
              Text(
                'Notre application est conçue pour offrir une expérience fluide et agréable à nos utilisateurs. Nous nous efforçons de fournir des fonctionnalités et des services de haute qualité qui répondent aux besoins de notre communauté.',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Notre équipe :'),
              const SizedBox(height: 10),
              _buildTeamMember(
                  'Junior OINDA - fondateur et directeur technique'),
              _buildTeamMember('Jude MPOYO - Développeur Web et Mobile'),
              const SizedBox(height: 20),
              _buildSectionTitle('Historique de l\'agence :'),
              const SizedBox(height: 10),
              Text(
                'APPIMMO a été créée en 2024  par un groupe de professionnels de l\'immobilier passionnés par leur métier. Depuis sa création, l\'agence a aidé des centaines de personnes à trouver leur bien immobilier idéal.',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Contactez-nous :'),
              const SizedBox(height: 10),
              _buildContactInfo(
                context,
                '+243975889135',
                'https://wa.me/+243975889135',
              ),
              const SizedBox(height: 10),
              _buildContactInfo(
                context,
                'Email : mpoyojude0@gmail.com',
                'mailto:mpoyojude0@gmail.com',
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Suivez-nous sur les réseaux sociaux :'),
              const SizedBox(height: 10),
              _buildSocialMediaIcons(context),
              const SizedBox(height: 20),
              _buildSectionTitle('Conditions d\'utilisation :'),
              const SizedBox(height: 10),
              Text(
                'En utilisant notre application, vous acceptez nos conditions d\'utilisation.',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 10),
              _buildSectionTitle('Politique de confidentialité :'),
              const SizedBox(height: 10),
              Text(
                'Nous prenons votre vie privée au sérieux. Veuillez lire notre politique de confidentialité pour plus d\'informations.',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Liens utiles :'),
              const SizedBox(height: 10),
              _buildUsefulLink(
                context,
                'Site web',
                'https://www.appimmo.com',
              ),
              const SizedBox(height: 10),
              _buildUsefulLink(
                context,
                'Blog',
                'https://www.appimmo.com/blog',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTeamMember(String member) {
    return Text(
      member,
      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
    );
  }

  Widget _buildContactInfo(BuildContext context, String text, String url) {
    return GestureDetector(
      onTap: () async {
        final Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Impossible de lancer l\'action'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Text(
        text,
        style: TextStyle(
            fontSize: 18,
            color: settingsController.primaryColor,
            decoration: TextDecoration.underline),
      ),
    );
  }

  Widget _buildSocialMediaIcon(
      String url, IconData icon, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Impossible de lancer le réseau social'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: FaIcon(
        icon,
        size: 30,
        color: settingsController.primaryColor,
      ),
    );
  }

  Widget _buildSocialMediaIcons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialMediaIcon('https://www.facebook.com/example',
            FontAwesomeIcons.facebook, context),
        const SizedBox(width: 10),
        _buildSocialMediaIcon('https://www.twitter.com/example',
            FontAwesomeIcons.twitter, context),
        const SizedBox(width: 10),
        _buildSocialMediaIcon('https://www.instagram.com/example',
            FontAwesomeIcons.instagram, context),
      ],
    );
  }

  Widget _buildUsefulLink(BuildContext context, String text, String url) {
    return GestureDetector(
      onTap: () async {
        final Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Impossible de lancer le lien'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Text(
        text,
        style: TextStyle(
            fontSize: 18,
            color: settingsController.primaryColor,
            decoration: TextDecoration.underline),
      ),
    );
  }
}
