import SwiftUI

struct ContentView: View {
    @StateObject private var vm = TaskViewModel()
    @FocusState private var focused: Bool

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            listArea
            Divider()
            footer
        }
        .frame(minWidth: 520, minHeight: 420)
        .background(.thinMaterial)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("TO DO LIST")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .padding(.top, 8)

            HStack(spacing: 8) {
                TextField("Wpisz zadanie…", text: $vm.newTitle)
                    .textFieldStyle(.roundedBorder)
                    .focused($focused)
                    .onSubmit(add)
                Picker("", selection: $vm.selectedPriority) {
                    ForEach(Priority.allCases) { p in
                        Text(p.rawValue.capitalized).tag(p)
                    }
                }
                .pickerStyle(.segmented)
                Button("Add", action: add)
                    .keyboardShortcut(.defaultAction)
            }

            HStack(spacing: 8) {
                Picker("Filter", selection: $vm.filter) {
                    ForEach(TaskFilter.allCases) { f in
                        Text(f.rawValue.capitalized).tag(f)
                    }
                }
                .pickerStyle(.segmented)
                Picker("Sort", selection: $vm.sort) {
                    ForEach(TaskSort.allCases) { s in
                        Text(s.rawValue.capitalized).tag(s)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }

    private var listArea: some View {
        List {
            ForEach(vm.visibleTasks) { item in
                TaskRowView(item: item,
                            onToggle: { vm.toggle(item) },
                            onDelete: { vm.remove(item) })
            }
        }
        .listStyle(.inset)
    }

    private var footer: some View {
        HStack {
            Text(counterText)
                .foregroundStyle(.secondary)
            Spacer()
        }
        .padding(12)
        .background(.ultraThinMaterial)
    }

    private var counterText: String {
        let n = vm.remainingCount
        return n == 1 ? "1 task remaining" : "\(n) tasks remaining"
    }

    private func add() {
        vm.addTask()
        focused = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .frame(width: 640, height: 480)
    }
}
