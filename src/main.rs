
use qtbridge::{QApp};

mod backend;        // App logic
mod res;            // QRC resources

fn main() {
    res::init();
    QApp::new()
        .register::<backend::Backend>()
        .add_import_path("qrc:/qml")
        .load_qml_from_file("qrc:/qml/Main.qml")
        .run();
}

