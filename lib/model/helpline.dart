class Helpline {
  final String name;
  final String description;
  final String phoneNumber;
  final String website;

  Helpline({
    required this.name,
    required this.description,
    required this.phoneNumber,
    required this.website,
  });
}

final List<Helpline> helplines = [
  Helpline(
    name: "Befrienders Kuala Lumpur",
    description: "Befrienders KL offers free and confidential emotional support to anyone feeling distressed, depressed, or suicidal. It's a safe space where you can talk about anything that is troubling you while remaining anonymous.",
    phoneNumber: "03-76272929",
    website: "https://www.befrienders.org.my/",
  ),
  Helpline(
    name: "MIASA Crisis Helpline",
    description: "We are here for everyone in Malaysia who may be struggling or looking for support with abuse & domestic violence, anxiety, bullying, and more.",
    phoneNumber: "1-800-18-0066",
    website: "https://miasa.org.my/",
  ),
  Helpline(
    name: "Talian Kasih",
    description: "Talian Kasih provides support for abuse, counseling, homelessness, child protection, reproductive health services, and more.",
    phoneNumber: "15999",
    website: "http://moh.gov.my/ncemh",
  ),
  Helpline(
    name: "Narcotics Anonymous Malaysia",
    description: "Our Narcotics Anonymous (NA) Malaysia Helpline is a confidential resource available to anyone struggling with drug addiction.",
    phoneNumber: "011-15114022",
    website: "https://www.namalaysia.my/",
  ),
];
