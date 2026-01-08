import { QuartzComponent, QuartzComponentConstructor, QuartzComponentProps } from "./types"
import RecentNotes from "./RecentNotes"

const RecentNotesForIndex: QuartzComponentConstructor = () => {
  const Component: QuartzComponent = (props: QuartzComponentProps) => {
    const { fileData } = props

    // index 페이지에서만 최근 글 목록 표시
    if (fileData.slug === "index") {
      const RecentNotesComponent = RecentNotes({
        title: "Recent Posts",
        limit: 5,
        showTags: true,
        linkToMore: "all-posts" as any,
      })
      return <RecentNotesComponent {...props} />
    }

    return null
  }

  Component.displayName = "RecentNotesForIndex"
  return Component
}

export default RecentNotesForIndex
