import { useState } from "react";

import homeScreen from "../assets/home_screen.png";
import detectorScreen from "../assets/detector_screen.png";
import settingsScreen from "../assets/settings_screen.png";

const ImageCarousel = () => {
  const images = [homeScreen, detectorScreen, settingsScreen];

  const [currentIndex, setCurrentIndex] = useState(0);

  const goToPrevious = () => {
    setCurrentIndex((prevIndex) =>
      prevIndex === 0 ? images.length - 1 : prevIndex - 1
    );
  };

  const goToNext = () => {
    setCurrentIndex((prevIndex) =>
      prevIndex === images.length - 1 ? 0 : prevIndex + 1
    );
  };

  return (
    <div style={styles.carouselContainer}>
      <button onClick={goToPrevious} style={styles.button}>
        ❮
      </button>
      <img
        src={images[currentIndex]}
        alt={`Slide ${currentIndex}`}
        style={styles.image}
      />
      <button onClick={goToNext} style={styles.button}>
        ❯
      </button>
    </div>
  );
};

const styles: { [key: string]: React.CSSProperties } = {
  carouselContainer: {
    display: "flex",
    alignItems: "center",
    justifyContent: "center",
    width: "100%",
    maxWidth: "600px",
    margin: "0 auto",
    position: "relative",
  },
  image: {
    width: "100%",
    height: "auto",
    borderRadius: "8px",
  },
  button: {
    background: "none",
    border: "none",
    fontSize: "2rem",
    cursor: "pointer",
    padding: "10px",
    zIndex: 2,
  },
};

export default ImageCarousel;
