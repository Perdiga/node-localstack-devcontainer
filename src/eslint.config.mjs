import globals from "globals";

export default [{
    files: ["**/*.spec.js", "**/*.spec.jsx"],

    languageOptions: {
        globals: {
            ...globals.jest,
        },
    },
}];