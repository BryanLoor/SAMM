import * as React from "react";
import { DataGrid, GridToolbar } from "@mui/x-data-grid";
import { useDemoData } from "@mui/x-data-grid-generator";
import Layout from "components/layout";
import ModalVisita from "./modal-crear-visita";

const VISIBLE_FIELDS = ["name", "rating", "country", "dateCreated", "isAdmin"];

const VisitasPage = () => {
  const { data } = useDemoData({
    dataSet: "Employee",
    visibleFields: VISIBLE_FIELDS,
    rowLength: 100,
  });

  return (
    <Layout>
      <ModalVisita />
      <div style={{ height: 400, width: "100%" }}>
        <DataGrid {...data} slots={{ toolbar: GridToolbar }} />
      </div>
    </Layout>
  );
};

export default VisitasPage;
