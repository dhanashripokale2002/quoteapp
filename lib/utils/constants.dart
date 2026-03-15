// lib/utils/constants.dart
import '../models/quote_model.dart';

class AppConstants {
  // Hive box names
  static const String quotesBox        = 'quotes_box';
  static const String favoritesBox     = 'favorites_box';
  static const String settingsBox      = 'settings_box';

  // Settings keys
  static const String themeKey         = 'theme_mode';
  static const String languageKey      = 'language_code';
  static const String dailyQuoteKey    = 'daily_quote_id';
  static const String dailyQuoteDateKey= 'daily_quote_date';

  // API
  static const String quotableBaseUrl  = 'https://api.quotable.io';
  static const String zenQuotesBaseUrl = 'https://zenquotes.io/api';
  static const int quotesPerPage       = 20;

  // Fallback quotes used when API is unreachable
  static final List<Map<String, dynamic>> fallbackQuotes = [
    // Motivation
    {
      'id': 'f001', 'text': 'Believe you can and you\'re halfway there.',
      'textHindi': 'विश्वास करो कि तुम कर सकते हो और तुम आधे रास्ते पर हो।',
      'author': 'Theodore Roosevelt', 'authorHindi': 'थियोडोर रूजवेल्ट', 'category': 'motivation',
    },
    {
      'id': 'f002', 'text': 'The only way to do great work is to love what you do.',
      'textHindi': 'महान कार्य करने का एकमात्र तरीका यह है कि आप जो करते हैं उससे प्यार करें।',
      'author': 'Steve Jobs', 'authorHindi': 'स्टीव जॉब्स', 'category': 'motivation',
    },
    {
      'id': 'f003', 'text': 'It always seems impossible until it\'s done.',
      'textHindi': 'जब तक यह हो नहीं जाता, यह हमेशा असंभव लगता है।',
      'author': 'Nelson Mandela', 'authorHindi': 'नेल्सन मंडेला', 'category': 'motivation',
    },
    {
      'id': 'f004', 'text': 'Don\'t watch the clock; do what it does. Keep going.',
      'textHindi': 'घड़ी मत देखो; जो वह करती है वो करो। चलते रहो।',
      'author': 'Sam Levenson', 'authorHindi': 'सैम लेवेन्सन', 'category': 'motivation',
    },
    {
      'id': 'f005', 'text': 'Dream big and dare to fail.',
      'textHindi': 'बड़े सपने देखो और असफल होने का साहस करो।',
      'author': 'Norman Vaughan', 'authorHindi': 'नॉर्मन वॉन', 'category': 'motivation',
    },

    // Success
    {
      'id': 's001', 'text': 'Success is not final, failure is not fatal: it is the courage to continue that counts.',
      'textHindi': 'सफलता अंतिम नहीं है, असफलता घातक नहीं है: जो मायने रखता है वह है जारी रखने का साहस।',
      'author': 'Winston Churchill', 'authorHindi': 'विंस्टन चर्चिल', 'category': 'success',
    },
    {
      'id': 's002', 'text': 'The road to success and the road to failure are almost exactly the same.',
      'textHindi': 'सफलता का रास्ता और असफलता का रास्ता लगभग बिल्कुल एक ही है।',
      'author': 'Colin R. Davis', 'authorHindi': 'कोलिन आर. डेविस', 'category': 'success',
    },
    {
      'id': 's003', 'text': 'Success usually comes to those who are too busy to be looking for it.',
      'textHindi': 'सफलता आमतौर पर उन लोगों के पास आती है जो इसे खोजने के लिए बहुत व्यस्त हैं।',
      'author': 'Henry David Thoreau', 'authorHindi': 'हेनरी डेविड थोरो', 'category': 'success',
    },
    {
      'id': 's004', 'text': 'I find that the harder I work, the more luck I seem to have.',
      'textHindi': 'मुझे लगता है कि जितना अधिक मैं काम करता हूं, उतना अधिक भाग्य मुझे मिलता है।',
      'author': 'Thomas Jefferson', 'authorHindi': 'थॉमस जेफरसन', 'category': 'success',
    },
    {
      'id': 's005', 'text': 'Coming together is a beginning; keeping together is progress; working together is success.',
      'textHindi': 'एक साथ आना एक शुरुआत है; एक साथ रहना प्रगति है; एक साथ काम करना सफलता है।',
      'author': 'Henry Ford', 'authorHindi': 'हेनरी फोर्ड', 'category': 'success',
    },

    // Life
    {
      'id': 'l001', 'text': 'Life is what happens when you\'re busy making other plans.',
      'textHindi': 'जीवन तब होता है जब आप अन्य योजनाएं बनाने में व्यस्त होते हैं।',
      'author': 'John Lennon', 'authorHindi': 'जॉन लेनन', 'category': 'life',
    },
    {
      'id': 'l002', 'text': 'In the end, it\'s not the years in your life that count. It\'s the life in your years.',
      'textHindi': 'अंत में, यह आपके जीवन के वर्ष नहीं बल्कि आपके वर्षों में जीवन मायने रखता है।',
      'author': 'Abraham Lincoln', 'authorHindi': 'अब्राहम लिंकन', 'category': 'life',
    },
    {
      'id': 'l003', 'text': 'Many of life\'s failures are people who did not realize how close they were to success when they gave up.',
      'textHindi': 'जीवन की कई असफलताएं वे लोग हैं जिन्हें यह नहीं पता था कि जब उन्होंने हार मान ली तो वे सफलता के कितने करीब थे।',
      'author': 'Thomas Edison', 'authorHindi': 'थॉमस एडिसन', 'category': 'life',
    },
    {
      'id': 'l004', 'text': 'You only live once, but if you do it right, once is enough.',
      'textHindi': 'आप केवल एक बार जीते हैं, लेकिन अगर आप इसे सही करते हैं, तो एक बार पर्याप्त है।',
      'author': 'Mae West', 'authorHindi': 'मे वेस्ट', 'category': 'life',
    },
    {
      'id': 'l005', 'text': 'The purpose of life is not to be happy. It is to be useful, to be honorable, to be compassionate.',
      'textHindi': 'जीवन का उद्देश्य खुश रहना नहीं है। यह उपयोगी, सम्मानजनक, दयालु होना है।',
      'author': 'Ralph Waldo Emerson', 'authorHindi': 'राल्फ वाल्डो एमर्सन', 'category': 'life',
    },

    // Love
    {
      'id': 'lo001', 'text': 'The best thing to hold onto in life is each other.',
      'textHindi': 'जीवन में एक-दूसरे को थामे रहना सबसे अच्छी बात है।',
      'author': 'Audrey Hepburn', 'authorHindi': 'ऑड्रे हेपबर्न', 'category': 'love',
    },
    {
      'id': 'lo002', 'text': 'I have decided to stick with love. Hate is too great a burden to bear.',
      'textHindi': 'मैंने प्यार के साथ रहने का फैसला किया है। नफरत बहुत बड़ा बोझ है।',
      'author': 'Martin Luther King Jr.', 'authorHindi': 'मार्टिन लूथर किंग जूनियर', 'category': 'love',
    },
    {
      'id': 'lo003', 'text': 'Where there is love there is life.',
      'textHindi': 'जहाँ प्यार है वहाँ जीवन है।',
      'author': 'Mahatma Gandhi', 'authorHindi': 'महात्मा गांधी', 'category': 'love',
    },
    {
      'id': 'lo004', 'text': 'We loved with a love that was more than love.',
      'textHindi': 'हमने एक ऐसे प्यार से प्यार किया जो प्यार से भी बढ़कर था।',
      'author': 'Edgar Allan Poe', 'authorHindi': 'एडगर एलन पो', 'category': 'love',
    },

    // Friendship
    {
      'id': 'fr001', 'text': 'A real friend is one who walks in when the rest of the world walks out.',
      'textHindi': 'एक सच्चा दोस्त वह है जो तब आता है जब बाकी दुनिया चली जाती है।',
      'author': 'Walter Winchell', 'authorHindi': 'वाल्टर विंचेल', 'category': 'friendship',
    },
    {
      'id': 'fr002', 'text': 'Friendship is born at the moment when one person says to another, "What? You too?"',
      'textHindi': 'दोस्ती उस पल पैदा होती है जब एक व्यक्ति दूसरे से कहता है, "क्या? तुम भी?"',
      'author': 'C.S. Lewis', 'authorHindi': 'सी.एस. लुईस', 'category': 'friendship',
    },
    {
      'id': 'fr003', 'text': 'Good friends are like stars. You don\'t always see them, but you know they\'re always there.',
      'textHindi': 'अच्छे दोस्त तारों जैसे होते हैं। आप उन्हें हमेशा नहीं देखते, लेकिन जानते हैं कि वे हमेशा वहाँ हैं।',
      'author': 'Unknown', 'authorHindi': 'अज्ञात', 'category': 'friendship',
    },

    // Relationship
    {
      'id': 'r001', 'text': 'The quality of your life is the quality of your relationships.',
      'textHindi': 'आपके जीवन की गुणवत्ता आपके रिश्तों की गुणवत्ता है।',
      'author': 'Anthony Robbins', 'authorHindi': 'एंथनी रॉबिंस', 'category': 'relationship',
    },
    {
      'id': 'r002', 'text': 'Treasure your relationships, not your possessions.',
      'textHindi': 'अपने रिश्तों को संजोकर रखें, अपनी संपत्ति को नहीं।',
      'author': 'Anthony J. D\'Angelo', 'authorHindi': 'एंथनी जे. डी\'एंजेलो', 'category': 'relationship',
    },

    // Mother
    {
      'id': 'm001', 'text': 'A mother\'s love is the fuel that enables a normal human being to do the impossible.',
      'textHindi': 'एक माँ का प्यार वह ईंधन है जो एक सामान्य इंसान को असंभव काम करने में सक्षम बनाता है।',
      'author': 'Marion C. Garretty', 'authorHindi': 'मैरियन सी. गैरेटी', 'category': 'mother',
    },
    {
      'id': 'm002', 'text': 'My mother is my root, my foundation. She planted the seed that I base my life on, and that is the belief that the ability to achieve starts in your mind.',
      'textHindi': 'मेरी माँ मेरी जड़ है, मेरी नींव। उसने वह बीज बोया जिस पर मैं अपना जीवन आधारित करता हूं।',
      'author': 'Michael Jordan', 'authorHindi': 'माइकल जॉर्डन', 'category': 'mother',
    },
    {
      'id': 'm003', 'text': 'Life doesn\'t come with a manual, it comes with a mother.',
      'textHindi': 'जीवन के साथ कोई मैनुअल नहीं आता, यह एक माँ के साथ आता है।',
      'author': 'Unknown', 'authorHindi': 'अज्ञात', 'category': 'mother',
    },

    // Father
    {
      'id': 'fa001', 'text': 'A father is someone you look up to no matter how tall you grow.',
      'textHindi': 'पिता वह है जिसे आप देखते हैं चाहे आप कितने भी बड़े हो जाएं।',
      'author': 'Unknown', 'authorHindi': 'अज्ञात', 'category': 'father',
    },
    {
      'id': 'fa002', 'text': 'My father gave me the greatest gift anyone could give another person, he believed in me.',
      'textHindi': 'मेरे पिता ने मुझे सबसे बड़ा उपहार दिया जो कोई दूसरे को दे सकता है, उन्होंने मुझ पर विश्वास किया।',
      'author': 'Jim Valvano', 'authorHindi': 'जिम वाल्वानो', 'category': 'father',
    },

    // Attitude
    {
      'id': 'at001', 'text': 'Your attitude, not your aptitude, will determine your altitude.',
      'textHindi': 'आपका रवैया, आपकी योग्यता नहीं, आपकी ऊंचाई निर्धारित करेगा।',
      'author': 'Zig Ziglar', 'authorHindi': 'ज़िग ज़िगलर', 'category': 'attitude',
    },
    {
      'id': 'at002', 'text': 'Ability is what you\'re capable of doing. Motivation determines what you do. Attitude determines how well you do it.',
      'textHindi': 'क्षमता वह है जो आप करने में सक्षम हैं। प्रेरणा निर्धारित करती है कि आप क्या करते हैं। रवैया निर्धारित करता है कि आप इसे कितनी अच्छी तरह करते हैं।',
      'author': 'Lou Holtz', 'authorHindi': 'लू होल्ट्ज़', 'category': 'attitude',
    },
    {
      'id': 'at003', 'text': 'Keep your face always toward the sunshine—and shadows will fall behind you.',
      'textHindi': 'अपना चेहरा हमेशा धूप की तरफ रखें—और परछाइयाँ आपके पीछे पड़ेंगी।',
      'author': 'Walt Whitman', 'authorHindi': 'वॉल्ट व्हिटमैन', 'category': 'attitude',
    },
  ];
}
