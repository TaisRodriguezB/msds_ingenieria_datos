// Fuente 4 (MongoDB): dimension de canal de venta
db = db.getSiblingDB("ejerciciodw");

db.canal_venta.insertMany([
  { id_canal: 1, nombre_canal: "Tienda Física",  tipo: "Presencial" },
  { id_canal: 2, nombre_canal: "En Línea",       tipo: "Digital" },
  { id_canal: 3, nombre_canal: "Teléfono",       tipo: "Presencial" },
  { id_canal: 4, nombre_canal: "Marketplace",    tipo: "Digital" }
]);
