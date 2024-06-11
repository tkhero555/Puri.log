import { application } from "./application"

import TabController from "./tab_controller"
application.register("tab", TabController)

import ModalController from "./modal_controller"
application.register("modal", ModalController)