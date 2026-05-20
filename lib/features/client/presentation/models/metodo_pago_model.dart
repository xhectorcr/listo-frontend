class MetodoPagoModel {
  final int idMetodoPago;
  final int idUsuario;
  final String usuario;
  final double saldo;
  final String marcaTarjeta;
  final String tokenSimulado;
  final String ultimosDigitos;
  final bool estado;

  MetodoPagoModel({
    required this.idMetodoPago,
    required this.idUsuario,
    required this.usuario,
    required this.saldo,
    required this.marcaTarjeta,
    required this.tokenSimulado,
    required this.ultimosDigitos,
    required this.estado,
  });


  factory MetodoPagoModel.fromJson(Map<String, dynamic> json) {
    return MetodoPagoModel(
      idMetodoPago: json['idMetodoPago'] ?? 0,
      idUsuario: json['idUsuario'] ?? 0,
      usuario: json['usuario'] ?? '',
   
      saldo: (json['saldo'] ?? 0).toDouble(),
      marcaTarjeta: json['marcaTarjeta'] ?? '',
      tokenSimulado: json['tokenSimulado'] ?? '',
      ultimosDigitos: json['ultimosDigitos'] ?? '',
      estado: json['estado'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idMetodoPago': idMetodoPago,
      'idUsuario': idUsuario,
      'usuario': usuario,
      'saldo': saldo,
      'marcaTarjeta': marcaTarjeta,
      'tokenSimulado': tokenSimulado,
      'ultimosDigitos': ultimosDigitos,
      'estado': estado,
    };
  }
}