import "../styles/globals.css";
import "../styles/SideBarMenu.scss";
import "../styles/SideBarMenuItemView.scss";
import "../styles/SideBarMenuCardView.scss";
import "tailwindcss/tailwind.css";

import React from "react";
import { Windmill } from "@roketid/windmill-react-ui";
import type { AppProps } from "next/app";
import Head from "next/head";
import { GlobalContextProvider } from "../context/GlobalContext";

function MyApp({ Component, pageProps }: AppProps) {
  // suppress useLayoutEffect warnings when running outside a browser
  if (!process.browser) React.useLayoutEffect = React.useEffect;

  return (
    <>
      <Head>
        <link rel="shortcut icon" href="/SAMM.ico" />
      </Head>
      <Windmill usePreferences={true}>
        <GlobalContextProvider>
          <Component {...pageProps} />
        </GlobalContextProvider>
      </Windmill>
    </>
  );
}
export default MyApp;
