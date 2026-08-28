
use qtbridge::{QApp};


// QRC Resoruces
#[path = "../res/mod.rs"]
mod res;

// App backend
mod backend;        // App logic

fn main() {
    res::init();
    QApp::new()
        .register::<backend::Backend>()
        .add_import_path("qrc:/qml")
        .load_qml_from_file("qrc:/qml/Main.qml")
        .run();
}

