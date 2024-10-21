class Coin {
  final int id;
  final String name;
  final String chainName;
  final double price;
  final double change24h;

  Coin({
    required this.id,
    required this.chainName,
    required this.name,
    required this.price,
    required this.change24h,
  });
}
List<Coin> coins = [
  Coin(
    id: 1,
    name: 'Bitcoin',
    chainName: 'BTC',
    price: 40000.00,
    change24h: 2.5,
  ),
  Coin(
    id: 2,
    name: 'Ethereum',
    chainName: 'ETH',
    price: 2500.00,
    change24h: -1.2,
  ),
];
