////  Guide.swift
//

nonisolated enum GuideStepState {
    case done
    case current
    case skipped
    case upcoming
}

nonisolated protocol Guide {
    associatedtype Step: CaseIterable, Comparable, Hashable

    var currentStep: Step { get set }
    var canContinue: Bool { get }

    func isSkipped(_ step: Step) -> Bool
}

nonisolated extension Guide {
    var stepNumber: Int {
        Step.allCases.count { step in step <= currentStep }
    }

    var stepCount: Int {
        Step.allCases.count
    }

    var nextStep: Step? {
        Step.allCases.first { step in
            step > currentStep && !isSkipped(step)
        }
    }

    var previousStep: Step? {
        Step.allCases.reversed().first { step in
            step < currentStep && !isSkipped(step)
        }
    }

    var stepStates: [GuideStepState] {
        Step.allCases.map { step in
            if isSkipped(step) {
                .skipped
            } else if step < currentStep {
                .done
            } else if step == currentStep {
                .current
            } else {
                .upcoming
            }
        }
    }
}
