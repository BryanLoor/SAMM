import React, { useEffect } from "react";
import mapboxgl, { Map, Marker } from "mapbox-gl";
import "mapbox-gl/dist/mapbox-gl.css";
import PageTitle from "example/components/Typography/PageTitle";
import Layout from "example/containers/Layout";
import { Card, CardBody, Label, Select } from "@roketid/windmill-react-ui";
import ModalRonda from "./modal-detalle-rondas";
import { get } from "utils/services/api";

mapboxgl.accessToken =
  "pk.eyJ1IjoiZ2VvbWVuYTIxIiwiYSI6ImNsam9zbHFjazFmcGQzcmxwdGJtbzl3OXgifQ.79ZyXG_5BxP5W0NGxVI8Gw";

function RegistroRondas() {
  const [agentes, setAgentes] = React.useState([]);
  const [selectedAgente, setSelectedAgente] = React.useState(); // agentes[0
  const [rondas, setRondas] = React.useState([]);
  const [selectedRonda, setSelectedRonda] = React.useState(); // rondas[0
  // Mapa de rondas
  const handleSelectAgente = (e: any) => {
    setSelectedAgente(e.target.value);
    const getRondas = async () => {
      const result = await get("/rondas/rondasAsignadas/" + e.target.value);
      console.log(result);
      setRondas(result["rondas"]);
      console.log(rondas);
    };
    getRondas();
  };
  useEffect(() => {
    const fetchAgentes = async () => {
      const result = await get("/visitas/personas/Agente");
      console.log(result);
      setAgentes(result["personas"]);
      console.log(agentes);
    };
    fetchAgentes();
    const mapContainer: HTMLElement | null = document.getElementById("map");

    if (mapContainer) {
      const map: Map = new mapboxgl.Map({
        container: mapContainer,
        style: "mapbox://styles/mapbox/streets-v11",
        center: [-0.09, 51.505],
        zoom: 13,
      });

      map.addControl(new mapboxgl.NavigationControl());
      map.addControl(new mapboxgl.FullscreenControl());

      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(
          (position) => {
            const { latitude, longitude } = position.coords;
            const userLocation: [number, number] = [longitude, latitude];

            // Agregar marcador en la ubicación del usuario
            new Marker().setLngLat(userLocation).addTo(map);

            // Marcadores adicionales
            const locations: [number, number][] = [
              [longitude + 0.01, latitude + 0.01],
              [longitude - 0.01, latitude - 0.01],
            ];

            // Agregar marcadores adicionales al mapa
            locations.forEach((location) => {
              new Marker().setLngLat(location).addTo(map);
            });

            // Ajustar el mapa para mostrar todos los marcadores
            const bounds = new mapboxgl.LngLatBounds();
            bounds.extend(userLocation);
            locations.forEach((location) => bounds.extend(location));
            map.fitBounds(bounds, { padding: 50 });
          },
          (error) => {
            console.error("Error al obtener la ubicación del usuario:", error);
          }
        );
      } else {
        console.error("Geolocalización no soportada por el navegador.");
      }
    }
  }, []);

  // Modal de detalle de rondas
  const [openModal, setOpenModal] = React.useState(false);

  const handleOpenModal = () => {
    setOpenModal(true);
  };

  return (
    <Layout>
      <PageTitle>Historial de Rondas</PageTitle>
      <hr />
      <div
        className="mt-12"
        style={{
          display: "grid",
          gridTemplateColumns: "auto 1fr",
          gap: "20px",
        }}
      >
        <div className="w-80">
          <Label className="">
            <span className="font-sans font-semibold text-[#0040AE]">
              Agente
            </span>
            <select
              className="mt-1 bg-[#297DE240] rounded-md border-gray-300"
              style={{ width: "100%" }}
              value={selectedAgente}
              onChange={(e) => {
                setSelectedAgente(e.target.value);
              }}
            >
              <option value="">Escoja el agente</option>
              {agentes.map((agente) => (
                <option key={agente.id} value={agente.id}>
                  {agente.nombres}
                </option>
              ))}
            </select>
          </Label>
          <Label className="mt-8">
            <span className="font-sans font-semibold text-[#0040AE]">
              Rondas asignadas
            </span>
            <select
              className="mt-1 bg-[#297DE240] rounded-md border-gray-300"
              style={{ width: "100%" }}
              value={selectedRonda}
              onChange={(e) => {
                setSelectedRonda(e.target.value);
              }}
            >
              <option value="">Escoja la ronda</option>
              {rondas.map((ronda) => (
                <option key={ronda.Id} value={ronda.Id}>
                  {ronda.Desripcion}
                </option>
              ))}
            </select>
          </Label>

          <Card className="mt-10 border-solid border-2 border-[#0040AE] shadow-md">
            <CardBody>
              <h3 className="text-lg text-[#001554] text-center  font-semibold">
                Información Ronda
              </h3>
              <hr />
              <div className="grid gap-4 mt-4 ml-4">
                {/* Hora de inicio */}
                <Label>
                  <span className="font-sans text-base text-[#001554]">
                    Hora de inicio:
                  </span>
                </Label>

                {/* Hora de fin */}
                <Label>
                  <span className="font-sans text-base text-[#001554]">
                    Hora de fin:
                  </span>
                </Label>

                {/* Completada */}
                <Label>
                  <span className="font-sans text-base text-[#001554]">
                    Completada:
                  </span>
                </Label>

                {/* Observaciones */}
                <Label>
                  <span className="font-sans text-base text-[#001554]">
                    Observaciones:
                  </span>

                  <ModalRonda />
                </Label>

                {/* Imágenes adjuntas */}
                <Label>
                  <span className="font-sans text-base text-[#001554]">
                    Imágenes adjuntas:
                  </span>

                  <ModalRonda />
                </Label>
              </div>
            </CardBody>
          </Card>
        </div>
        <div
          id="map"
          className="ml-6 shadow-lg"
          style={{
            minHeight: "450px",
            minWidth: "660px",
            maxWidth: "100%",
            maxHeight: "100%",
            borderRadius: "8px",
            border: "2px solid #0040AE",
          }}
        />
      </div>
    </Layout>
  );
}

export default RegistroRondas;
