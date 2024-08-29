class Article {
  final String name;
  final String url;

  Article({
    required this.name,
    required this.url,
  });
}

final List<Article> articles = [
  Article(name: "Mental Health Foundation", url: "https://www.mentalhealth.org.uk/a-to-z"),
  Article(name: "Psychology Today", url: "https://www.psychologytoday.com/us"),
  Article(name: "Mind", url: "https://www.mind.org.uk/information-support/tips-for-everyday-living/"),
];