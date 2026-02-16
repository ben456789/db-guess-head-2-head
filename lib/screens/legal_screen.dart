import 'package:flutter/material.dart';
import 'package:poke_guess_head_2_head/screens/privacy_policy_screen.dart';
import '../l10n/app_localizations.dart';

class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.legalTerms,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24.0),
              children: [
                ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.eula,
                    style: const TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.white,
                        title: Text(
                          AppLocalizations.of(context)!.eulaTitle,
                          style: const TextStyle(color: Colors.black),
                        ),
                        content: Text(
                          AppLocalizations.of(context)!.eulaContent,
                          style: const TextStyle(color: Colors.black),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              AppLocalizations.of(context)!.close,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.privacyPolicy,
                    style: const TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.termsOfService,
                    style: const TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.white,
                        title: Text(
                          AppLocalizations.of(context)!.termsOfService,
                          style: const TextStyle(color: Colors.black),
                        ),
                        content: Text(
                          AppLocalizations.of(context)!.termsOfServiceContent,
                          style: const TextStyle(color: Colors.black),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              AppLocalizations.of(context)!.close,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Text(
            AppLocalizations.of(context)!.pokemonTrademarkNotice,
            style: TextStyle(color: Colors.grey[700], fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

// Make sure PrivacyPolicyScreen exists or is imported properly.
