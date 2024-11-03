class Constants {

  static const String urlBase = 'https://4bc4-2c0f-eb58-6c7-bf00-634d-4145-8eb5-930d.ngrok-free.app';

  static const String urlPharmacieGarde = 'https://pharmapi-tohtss4kua-uc.a.run.app/v1/api/pharmacie/ouaga';
  static const String urlProduitPageable = urlBase+'/v1/api/produit?size=10&page=70';
  static const String urlLogin = urlBase+'/v1/api/utilisateur/login';
  static const String urlRegister = urlBase+'/v1/api/utilisateur/save';

  static const String urlCommandeSave = urlBase+'/v1/api/commande/save';
  static const String urlFindUserCommande = urlBase+'/v1/api/commande/find';
  static const String urlFindPharmacieCommande = urlBase+'/v1/api/commande/pharmacie';

}
