import 'package:http/http.dart' as http;
import 'dart:convert';

class TranslatorService {
  static Future<String> translateText(
      String text, String sourceLanguage, String targetLanguage) async {
    final apiKey = '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'; // Replace with your OpenAI API key
    final url = 'https://api.openai.com/v1/chat/completions';

    // Ensure input text is trimmed of unnecessary spaces
    final trimmedText = text.trim();

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: json.encode({
        'model': 'gpt-3.5-turbo', // Changed to a model more widely accessible
        'messages': [
          {
            'role': 'user',
            'content': 'Please translate the following text from $sourceLanguage to $targetLanguage: "$trimmedText".'
          }
        ],
        'temperature': 0.7,
        'max_tokens': 500,
        'top_p': 1,
        'frequency_penalty': 0,
        'presence_penalty': 0,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['choices'][0]['message']['content'].trim();
    } else if (response.statusCode == 400) {
      print('Response Status Code: 400 - Bad Request');
      print('Response Body: ${response.body}');
      throw Exception('Bad request - likely an issue with the input parameters.');
    } else if (response.statusCode == 401) {
      print('Response Status Code: 401 - Unauthorized');
      print('Response Body: ${response.body}');
      throw Exception('Unauthorized - check your API key.');
    } else if (response.statusCode == 429) {
      print('Response Status Code: 429 - Too Many Requests');
      print('Response Body: ${response.body}');
      throw Exception('Too many requests - you have hit the rate limit.');
    } else if (response.statusCode == 500) {
      print('Response Status Code: 500 - Internal Server Error');
      print('Response Body: ${response.body}');
      throw Exception('Internal server error - try again later.');
    } else {
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      throw Exception('Failed to get translation');
    }
  }
}

