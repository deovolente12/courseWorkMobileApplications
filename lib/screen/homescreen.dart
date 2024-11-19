import 'package:flutter/material.dart';
import 'package:coursework_jongsungkim/controllers/translator_controller.dart';
import 'package:coursework_jongsungkim/services/connectivity_service.dart';

import 'loginscreen.dart';

class NeurotolgeHomePage extends StatefulWidget {
  @override
  _NeurotolgeHomePageState createState() => _NeurotolgeHomePageState();
}

class _NeurotolgeHomePageState extends State<NeurotolgeHomePage> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _outputController = TextEditingController();
  String _sourceLanguage = 'English';
  String _targetLanguage = 'Estonian';

  Future<void> _translateText() async {
    final String inputText = _inputController.text;
    if (inputText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter text to translate')),
      );
      return;
    }

    if (!await ConnectivityService.isConnected()) {
      // No internet connection
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No internet connection. Please check your network settings.")),
      );
      return;
    }

    try {
      final translatedText = await TranslatorController.translateText(
        inputText,
        _getLanguageCode(_sourceLanguage),
        _getLanguageCode(_targetLanguage),
      );
      setState(() {
        _outputController.text = translatedText;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  String _getLanguageCode(String language) {
    switch (language) {
      case 'English':
        return 'en';
      case 'Estonian':
        return 'et';
      case 'Russian':
        return 'ru';
      case 'Finnish':
        return 'fi';
      case 'Korean':
        return 'ko';
      default:
        return 'en';
    }
  }


  void _goBackToLogin() {
    // Navigate back to login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Translator'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      'Supported Languages',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        _buildChoiceChip('Estonian'),
                        _buildChoiceChip('English'),
                        _buildChoiceChip('Russian'),
                        _buildChoiceChip('Finnish'),
                        _buildChoiceChip('Korean'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              Text(
                'Translate Text',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              _buildTextInputSection(),
              SizedBox(height: 32),
              Text(
                'Translated Results',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              _buildTranslatedResultSection(),
              SizedBox(height: 32),
              // Add the Back to Login Button
              Center(
                child: ElevatedButton(
                  onPressed: _goBackToLogin,
                  child: Text('Back to Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceChip(String language) {
    return ChoiceChip(
      label: Text(language),
      selected: _targetLanguage == language,
      onSelected: (bool selected) {
        setState(() {
          if (selected) {
            _targetLanguage = language;
          }
        });
      },
    );
  }

  Widget _buildTextInputSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter text to translate',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _inputController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Type your text here...',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _translateText,
            child: Text('Translate'),
          ),
        ],
      ),
    );
  }

  Widget _buildTranslatedResultSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Translated Results',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _outputController,
            maxLines: 5,
            readOnly: true,
            decoration: InputDecoration(
              hintText: 'Translation will appear here...',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}