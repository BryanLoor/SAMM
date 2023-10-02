import React, { useCallback, useState } from "react";
import { utils, writeFileXLSX } from "xlsx";

export default function ExportToExcelButton({ data }) {
  /* Estado local para controlar el archivo XLSX */
  const [exported, setExported] = useState(false);

  /* Función para exportar los datos a un archivo XLSX */
  const exportFile = useCallback(() => {
    const ws = utils.json_to_sheet(data);
    const wb = utils.book_new();
    utils.book_append_sheet(wb, ws, "Data");
    writeFileXLSX(wb, "exported-data.xlsx");
    setExported(true); // Actualizar el estado para indicar que se ha exportado
  }, [data]);

  return (
    <div>
      <button onClick={exportFile}>Exportar a XLSX</button>
      {exported && <p>¡Datos exportados!</p>}
    </div>
  );
}
