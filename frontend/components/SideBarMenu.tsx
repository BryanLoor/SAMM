import { useState } from "react";
import { SideBarMenuCard, SideBarMenuItem } from "types/types";
import { classNames } from "utils/classes";
import { GiHamburgerMenu } from "react-icons/gi";
import { SideBarMenuCardView } from "./SideBarMenuCardView";
import { SideBarMenuItemView } from "./SideBarMenuItemView";
import { FiLogOut } from "react-icons/fi";
import { useRouter } from "next/router";

interface SideBarMenuProps {
  items: SideBarMenuItem[];
  card: SideBarMenuCard;
}

export function SideBarMenu({ items, card }: SideBarMenuProps) {
  const [isOpen, setIsOpen] = useState<boolean>(true);
  function handleClick() {
    setIsOpen(!isOpen);
  }
  const router = useRouter();

  return (
    <div
      className={classNames("SideBarMenu", isOpen ? "expanded" : "collapsed")}
    >
      <div
        className="menuButton"
        style={{
          display: "flex",
          flexDirection: "column",
          marginTop: "15px",
          paddingRight: "20px",
          fontSize: "20px",
        }}
      >
        <button
          onClick={() => router.push("/")}
          style={{ margin: "0 0 0 auto", marginBottom: "15px" }}
        >
          <FiLogOut />
        </button>
        <button onClick={handleClick} style={{ margin: "0 0 0 auto" }}>
          <GiHamburgerMenu />
        </button>
      </div>
      <SideBarMenuCardView key={card.id} card={card} isOpen={isOpen} />
      <div style={{ marginTop: "15px" }}>
        {items.map((item) => (
          <SideBarMenuItemView key={item.id} item={item} isOpen={isOpen} />
        ))}
      </div>
    </div>
  );
}
