import { createContext, useContext, useState } from "react";

export const GlobalContext = createContext("");

export function GlobalContextProvider({ children }) {
  //Rondas
  const [rondaSelected, setRondaSelected] = useState({});

  const values = {
    rondaSelected,
    setRondaSelected,
  };

  return (
    <GlobalContext.Provider value={values}>{children}</GlobalContext.Provider>
  );
}
