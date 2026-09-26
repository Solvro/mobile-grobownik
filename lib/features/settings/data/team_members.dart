class TeamMember {
  const TeamMember({required this.name, required this.role});

  final String name;
  final String role;
}

//Static Filler
abstract final class TeamMembers {
  static const clubName = "KN Solvro";
  static const clubDescription =
      "Koło Naukowe Solvro działające przy Politechnice Wrocławskiej. "
      "Tworzymy aplikacje i rozwiązania technologiczne dla społeczności akademickiej.";
  static const websiteUrl = "https://solvro.pl";
  static const githubUrl = "https://github.com/Solvro/mobile-grobownik";

  static const members = <TeamMember>[TeamMember(name: "KN Solvro", role: "Zespół projektowy")];
}
